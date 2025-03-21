# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-24.05"; # or "unstable"
  services.docker.enable = true;

  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.git
    pkgs.zsh
    pkgs.python311
    pkgs.python311Packages.pip
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
      "ms-python.black-formatter"
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
# [ -f ./guidelines_for_writing_neo4j_database_queries.md ] || wget -q -O ./guidelines_for_writing_neo4j_database_queries.md https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/mQDu7dkNmKa1_Q
# [ -f ./guidelines_for_writing_with_pandas.md ] || wget -q -O ./guidelines_for_writing_with_pandas.md https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/-dbtNBtZDwoJAQ
# [ -f ./guidelines_for_scikit_learn_pipline.md ] || wget -q -O ./guidelines_for_scikit_learn_pipline.md https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/JDFedneGBhYH-w
# [ -f ./guidelines_for_data_analysis_with_scikit_learn.md ] || wget -q -O ./guidelines_for_data_analysis_with_scikit_learn.md https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/t8QAqxnj-JzP4g
# [ -f ./guidelines_feature_engineering.md ] || wget -q -O ./guidelines_feature_engineering.md https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/EUpvgg0KOhHLpA
# [ -f ./general_rules.md ] || wget -q -O ./general_rules.md https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/EUpvgg0KOhHLpA
# [ -f ./guidelines_for_writing_FastAPI.md ] || wget -q -O ./guidelines_for_writing_FastAPI.md https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/-qpcsdP3VN0i7w

	onCreate = {
		create-venv = ''
      if ! git status &> /dev/null; then git init && git add *; fi
      [ -f ./rules_for_writing_with_python.md ] || wget -q -O ./rules_for_writing_with_python.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_writing_with_python.md
      [ -f ./rules_for_writing_tests_FastAPI.md ] || wget -q -O ./rules_for_writing_tests_FastAPI.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_writing_tests_FastAPI.md
      [ -f ./guidelines_for_writing_with_pandas.md ] || wget -q -O ./guidelines_for_writing_with_pandas.md https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/-dbtNBtZDwoJAQ
      [ -f ./guidelines_for_scikit_learn_pipline.md ] || wget -q -O ./guidelines_for_scikit_learn_pipline.md https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/JDFedneGBhYH-w
      [ -f ./guidelines_for_data_analysis_with_scikit_learn.md ] || wget -q -O ./guidelines_for_data_analysis_with_scikit_learn.md https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/t8QAqxnj-JzP4g
      [ -f ./guidelines_feature_engineering.md ] || wget -q -O ./guidelines_feature_engineering.md https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/EUpvgg0KOhHLpA
      [ -f ./general_rules.md ] || wget -q -O ./general_rules.md https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/EUpvgg0KOhHLpA
      if ! find . -name "*.toml" | grep -q .; then poetry init; fi
      poetry shell
      poetry update
      poetry env info
		'';
      };
# Runs when the workspace is (re)started
	onStart = {
		active-venv = ''
      if ! git status &> /dev/null; then git init && git add *; fi
      [ -f ./rules_for_writing_with_python.md ] || wget -q -O ./rules_for_writing_with_python.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_writing_with_python.md
      [ -f ./rules_for_writing_tests_FastAPI.md ] || wget -q -O ./rules_for_writing_tests_FastAPI.md https://raw.githubusercontent.com/cappelchi/rules/refs/heads/master/rules_for_writing_tests_FastAPI.md
      [ -f ./guidelines_for_writing_with_pandas.md ] || wget -q -O ./guidelines_for_writing_with_pandas.md https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/-dbtNBtZDwoJAQ
      [ -f ./guidelines_for_scikit_learn_pipline.md ] || wget -q -O ./guidelines_for_scikit_learn_pipline.md https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/JDFedneGBhYH-w
      [ -f ./guidelines_for_data_analysis_with_scikit_learn.md ] || wget -q -O ./guidelines_for_data_analysis_with_scikit_learn.md https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/t8QAqxnj-JzP4g
      [ -f ./guidelines_feature_engineering.md ] || wget -q -O ./guidelines_feature_engineering.md https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/EUpvgg0KOhHLpA
      [ -f ./general_rules.md ] || wget -q -O ./general_rules.md https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/EUpvgg0KOhHLpA 
      if ! find . -name "*.toml" | grep -q .; then poetry init; fi
      poetry shell
      poetry update
      poetry env info
		'';
      };
    };
  };
}
