_: {
  cfTunnels."git.uku3lig.net" = "http://localhost:3000";

  services.forgejo = {
    enable = true;

    database = {
      type = "postgres";
      createDatabase = true;
    };

    settings = {
      DEFAULT.APP_NAME = "uku's forge";

      server = {
        DISABLE_SSH = true;
        ROOT_URL = "https://git.uku3lig.net";
      };

      service = {
        ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
        # TODO enable turnstile once it gets fixed
        # see codeberg:forgejo/forgejo#3832
        ENABLE_CAPTCHA = true;
      };

      oauth2 = {
        # providers are configured in the admin panel
        ENABLED = true;
      };

      actions.ENABLED = false;

      "ui.meta" = {
        AUTHOR = "uku's forge";
        DESCRIPTION = "the place where literally nothing gets done";
      };

      "repository.signing" = {
        DEFAULT_TRUST_MODEL = "committer";
      };
    };
  };
}
