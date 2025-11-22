{ config, _utils, ... }:
let
  envFile = _utils.setupSingleSecret config "paperlessEnv" { };
in
{
  imports = [ envFile.generate ];

  services.paperless = {
    enable = true;
    domain = "paper.uku3lig.net";

    environmentFile = envFile.path;
    database.createLocally = true;

    address = "0.0.0.0";
    settings = {
      PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
      PAPERLESS_OCR_LANGUAGE = "fra+ita+eng";
      PAPERLESS_ENABLE_NLTK = true;
      PAPERLESS_DATE_PARSER_LANGUAGES = "fr+it+en";
    };
  };
}
