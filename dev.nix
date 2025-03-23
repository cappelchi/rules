# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-24.05"; # or "unstable"
  services.docker.enable = false;

  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.git
    pkgs.python312
    pkgs.python312Packages.pip
    pkgs.python311
    pkgs.python311Packages.pip
    pkgs.python310
    pkgs.python310Packages.pip
    pkgs.poetry
  ];

  # Sets environment variables in the workspace
  env = {
    HELLO = "world";
  };
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "ms-python.python"
      "ms-python.debugpy"
      "ms-toolsai.jupyter"
      "charliermarsh.ruff"
      "bracket-pair-colorizer-2"
      "eduarbo.relative-file-navigator"
      "solomonkinard.vsix-lens"
      "michelemelluso.gitignore"
    ];

    # Enable previews
    #previews = {
    #  enable = true;
    #  previews = {
    #    web = {
    #    #   # Example: run "npm run dev" with PORT set to IDX's defined port for previews,
    #    #   # and show it in IDX's web preview panel
    #    command = [];
    #    cwd = "/home/user/app-python";
    #    manager = "web";
    #    #id = "web";
    #    env = {
    #    #     # Environment variables to set for your server
    #      HELLO = "world";
    #    };
    #    };
    #  };
    #};
# Workspace lifecycle hooks
workspace = {
# Runs when a workspace is first created
# cat requirements.txt | xargs poetry add
# poetry self update
# [ -f ./rules_for_writing_with_python.md ] || wget -q -O ./rules_for_writing_with_python.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_writing_with_python.md
# [ -f ./rules_for_writing_tests_FastAPI.md ] || wget -q -O ./rules_for_writing_tests_FastAPI.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_writing_tests_FastAPI.md
# [ -f ./rules_for_writing_Neo4j_queries.md ] || wget -q -O ./rules_for_writing_Neo4j_queries.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_writing_Neo4j_queries.md
# [ -f ./rules_for_writing_with_pandas.md ] || wget -q -O ./rules_for_writing_with_pandas.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_writing_with_pandas.md
# [ -f ./rules_for_writing_with_scikit_learn.md ] || wget -q -O ./rules_for_writing_with_scikit_learn.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_writing_with_scikit_learn.md
# [ -f ./rules_for_data_analysis_with_scikit_learn.md ] || wget -q -O ./rules_for_data_analysis_with_scikit_learn.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_data_analysis_with_scikit_learn.md
# [ -f ./general_rules.md ] || wget -q -O ./general_rules.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/general_rules.md

	onCreate = {
		create-venv = ''
      if ! git status &> /dev/null; then git init; fi
      [ -f ./rules_for_writing_with_python.md ] || wget -q -O ./rules_for_writing_with_python.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_writing_with_python.md
      [ -f ./rules_for_writing_tests_FastAPI.md ] || wget -q -O ./rules_for_writing_tests_FastAPI.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_writing_tests_FastAPI.md
      [ -f ./rules_for_writing_with_pandas.md ] || wget -q -O ./rules_for_writing_with_pandas.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_writing_with_pandas.md
      [ -f ./rules_for_writing_with_scikit_learn.md ] || wget -q -O ./rules_for_writing_with_scikit_learn.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_writing_with_scikit_learn.md
      [ -f ./rules_for_data_analysis_with_scikit_learn.md ] || wget -q -O ./rules_for_data_analysis_with_scikit_learn.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_data_analysis_with_scikit_learn.md
      [ -f ./general_rules.md ] || wget -q -O ./general_rules.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/general_rules.md
      if [ ! -f pyproject.toml ]; then poetry init; fi
            # Условная активация poetry shell
      if poetry env info | grep -q 'Virtualenv'; then
        echo "Poetry shell already active (onCreate)."
      else
        echo "Activating poetry shell (onCreate)..."
        poetry shell
      fi
      poetry update
      poetry env info
		'';
      };
# Runs when the workspace is (re)started
	onStart = {
		active-venv = ''
      if ! git status &> /dev/null; then git init; fi
      [ -f ./rules_for_writing_with_python.md ] || wget -q -O ./rules_for_writing_with_python.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_writing_with_python.md
      [ -f ./rules_for_writing_tests_FastAPI.md ] || wget -q -O ./rules_for_writing_tests_FastAPI.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_writing_tests_FastAPI.md
      [ -f ./rules_for_writing_with_pandas.md ] || wget -q -O ./rules_for_writing_with_pandas.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_writing_with_pandas.md
      [ -f ./rules_for_writing_with_scikit_learn.md ] || wget -q -O ./rules_for_writing_with_scikit_learn.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_writing_with_scikit_learn.md
      [ -f ./rules_for_data_analysis_with_scikit_learn.md ] || wget -q -O ./rules_for_data_analysis_with_scikit_learn.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_data_analysis_with_scikit_learn.md
      [ -f ./general_rules.md ] || wget -q -O ./general_rules.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/general_rules.md 
      if [ ! -f pyproject.toml ]; then poetry init; fi
      # Условная активация poetry shell
      if poetry env info | grep -q 'Virtualenv'; then
        echo "Poetry shell already active (onStart)."
      else
        echo "Activating poetry shell (onStart)..."
        poetry shell
      fi
      poetry update
      poetry env info
		'';
      };
    };
  };
}
