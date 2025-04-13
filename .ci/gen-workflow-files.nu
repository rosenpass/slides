#!/usr/bin/env nu

use std log

# cd to git root
cd (git rev-parse --show-toplevel)

# check if a subject depends on a potential dependency
def depends [
    subject:string # package to examine
    maybe_dep:string # maybe a dependency of subject
  ] {
  not ( nix why-depends --quiet --derivation $subject $maybe_dep | is-empty ) 
}

# get attribute names of the attribute set
def get-attr-names [
    expr: # nix expression to get attrNames of 
  ] {
  nix eval --json $expr --apply builtins.attrNames | from json
}

def job-id [
  system:string,
  derivation:string,
  ] {
  $"($system)---($derivation)"
}

# map from nixos system to github runner type
let systems_map = {
  x86_64-linux: ubuntu-latest
}

let targets = (get-attr-names ".#packages"
  | par-each {|system| { $system : (get-attr-names $".#packages.($system)") } }
  | reduce {|it, acc| $acc | merge $it }
)

mut cachix_workflow = {
  name: "Nix",
  permissions: {contents: write},
  on: {
    pull_request: null,
    push: {branches: [main]}
  },
  jobs: {},
}

let runner_setup = [
  {
    uses: "actions/checkout@v3"
  }
  {
    uses: "cachix/install-nix-action@v22",
    with: { nix_path: "nixpkgs=channel:nixos-unstable" }
  }
  {
    uses: "cachix/cachix-action@v12",
    with: {
      name: rosenpass-slides,
      authToken: "${{ secrets.CACHIX_AUTH_TOKEN }}"
    }
  }
]

for system in ($targets | columns) {
  if ($systems_map | get -i $system | is-empty) {
    log info $"skipping ($system), since there are no GH-Actions runners for it"
    continue
  }

  # lookup the correct runner for $system
  let runs_on = [ ($systems_map | get $system) ]

  # add jobs for all derivations
  let derivations = ($targets | get $system)
  for derivation in $derivations {

    # job_id for GH-Actions
    let id = ( job-id $system $derivation )

    # name displayed
    let name = $"($system).($derivation)"

    # collection of dependencies
    # TODO currently only considers dependencies on the same $system
    let needs = ($derivations
      | filter {|it| $it != $derivation and $it != "default" } # filter out self and default
      | par-each {|it| {
        name: $it, # the other derivation
        # does self depend on $it?
        needed: (depends $".#packages.($system).($derivation)" $".#packages.($system).($it)")
      } }
      | filter {|it| $it.needed}
      | each {|it| job-id $system $it.name}
    )

    mut new_job = {
      name: $"Build ($name)",
      "runs-on": $runs_on,
      needs: $needs,
      steps: ($runner_setup | append [
        {
          name: Build,
          run: $"nix build .#packages.($system).($derivation) --print-build-logs"
        }
        {
          name: "Deploy PDF artifacts",
          uses: "peaceiris/actions-gh-pages@v3",
          "if": "github.ref == 'refs/heads/main'",
          with: {
            github_token: "${{ secrets.GITHUB_TOKEN }}",
            publish_dir: result/,
            publish_branch: $"pdf/($derivation)",
            force_orphan: true
          }
        }
      ])
    }
    $cachix_workflow.jobs = ($cachix_workflow.jobs | insert $id $new_job )
  }

  # add check job
  $cachix_workflow.jobs = ($cachix_workflow.jobs | insert $"($system)---check" {
    name: $"Run Nix checks on ($system)",
    "runs-on": $runs_on,
    steps: ($runner_setup | append {
      name: Check,
      run: "nix flake check . --print-build-logs"
    })
  })

}

log info "saving nix-cachix workflow"
$cachix_workflow | to yaml | save --force .github/workflows/nix.yaml

log info "prettify generated yaml"
prettier -w .github/workflows/
