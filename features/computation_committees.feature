Feature: Computation Committee Calculations
  The computation model should generate correct committee calculations

  Background:
    Given a Computation

  Scenario: Date committee from timeframe
    Given a characteristic "timeframe" of "2009-06-06/2010-01-01"
    When the "date" committee reports
    Then the committee should have used quorum "from timeframe"
    And the conclusion of the committee should be "2009-06-06"

  Scenario: Duration commitee from default
    When the "duration" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "3600.0"

  Scenario: Carrier committee from default
    When the "carrier" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should have "name" of "fallback"

  Scenario: Carrier instance class committee from default
    When the "carrier_instance_class" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should have "name" of "fallback"

  Scenario: Electricity intensity committee from default carrier instance class
    When the "carrier_instance_class" committee reports
    And the "electricity_intensity" committee reports
    Then the committee should have used quorum "from carrier instance class"
    And the conclusion of the committee should be "0.1"

  Scenario: Electricity intensity committee from carrier instance class
    Given a characteristic "carrier_instance_class.name" of "Amazon m1.large"
    When the "electricity_intensity" committee reports
    Then the committee should have used quorum "from carrier instance class"
    And the conclusion of the committee should be "0.4"

  Scenario: Power usage effectiveness committee from default carrier
    When the "carrier" committee reports
    And the "power_usage_effectiveness" committee reports
    Then the committee should have used quorum "from carrier"
    And the conclusion of the committee should be "1.5"

  Scenario: Power usage effectiveness committee from carrier
    Given a characteristic "carrier.name" of "Amazon"
    When the "power_usage_effectiveness" committee reports
    Then the committee should have used quorum "from carrier"
    And the conclusion of the committee should be "1.5"

  Scenario: eGRID subregion committee from default
    When the "egrid_subregion" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should have "name" of "fallback"

  Scenario: eGRID subregion commitee from carrier region
    Given a characteristic "carrier_region.name" of "Amazon us-east-1a"
    When the "egrid_subregion" committee reports
    Then the committee should have used quorum "from carrier region"
    And the conclusion of the committee should have "abbreviation" of "SRVC"

  Scenario: eGRID subregion commitee from zip code
    Given a characteristic "zip_code.name" of "94122"
    When the "egrid_subregion" committee reports
    Then the committee should have used quorum "from zip code"
    And the conclusion of the committee should have "abbreviation" of "CAMX"

  Scenario: eGRID region committee from default eGRID subregion
    When the "egrid_subregion" committee reports
    And the "egrid_region" committee reports
    Then the committee should have used quorum "from eGRID subregion"
    And the conclusion of the committee should have "name" of "fallback"

  Scenario Outline: eGRID region committee eGRID subregion
    Given a characteristic "egrid_subregion.abbreviation" of "<subregion>"
    When the "egrid_region" committee reports
    Then the committee should have used quorum "from eGRID subregion"
    And the conclusion of the committee should have "name" of "<name>"
    Examples:
      | subregion | name |
      | SRVC      | E    |
      | CAMX      | W    |

  Scenario: Electricity loss factor committee from default eGRID region
    When the "egrid_subregion" committee reports
    And the "egrid_region" committee reports
    And the "electricity_loss_factor" committee reports
    Then the committee should have used quorum "from eGRID region"
    And the conclusion of the committee should be "0.06188"

  Scenario Outline: Electricity loss factor committee eGRID region
    Given a characteristic "egrid_region.name" of "<name>"
    When the "electricity_loss_factor" committee reports
    Then the committee should have used quorum "from eGRID region"
    And the conclusion of the committee should be "<loss_factor>"
    Examples:
      | name | loss_factor |
      | E    | 0.06        |
      | W    | 0.05        |

  Scenario: Electricity use commitee from defaults
    When the "duration" committee reports
    And the "carrier" committee reports
    And the "carrier_instance_class" committee reports
    And the "electricity_intensity" committee reports
    And the "power_usage_effectiveness" committee reports
    And the "egrid_subregion" committee reports
    And the "egrid_region" committee reports
    And the "electricity_loss_factor" committee reports
    And the "electricity_use" committee reports
    Then the committee should have used quorum "from duration, electricity intensity, PUE, and electricity loss factor"
    And the conclusion of the committee should be "0.15989"

  Scenario: Electricity use commitee from carrier, carrier instance class, and carrier region
    Given a characteristic "carrier.name" of "Amazon"
    And a characteristic "carrier_instance_class.name" of "Amazon m1.large"
    And a characteristic "carrier_region.name" of "Amazon us-east-1a"
    When the "duration" committee reports
    And the "electricity_intensity" committee reports
    And the "power_usage_effectiveness" committee reports
    And the "egrid_subregion" committee reports
    And the "egrid_region" committee reports
    And the "electricity_loss_factor" committee reports
    And the "electricity_use" committee reports
    Then the committee should have used quorum "from duration, electricity intensity, PUE, and electricity loss factor"
    And the conclusion of the committee should be "0.63830"

  Scenario: Electricity use commitee from carrier, carrier instance class, carrier region, and zip code
    Given a characteristic "carrier.name" of "Amazon"
    And a characteristic "carrier_instance_class.name" of "Amazon m1.large"
    And a characteristic "carrier_region.name" of "Amazon us-east-1a"
    And a characteristic "zip_code.name" of "94122"
    When the "duration" committee reports
    And the "electricity_intensity" committee reports
    And the "power_usage_effectiveness" committee reports
    And the "egrid_subregion" committee reports
    And the "egrid_region" committee reports
    And the "electricity_loss_factor" committee reports
    And the "electricity_use" committee reports
    Then the committee should have used quorum "from duration, electricity intensity, PUE, and electricity loss factor"
    And the conclusion of the committee should be "0.63158"

  Scenario: N2O emission factor from default
    When the "egrid_subregion" committee reports
    And the "n2o_emission_factor" committee reports
    Then the committee should have used quorum "from eGRID subregion"
    And the conclusion of the committee should be "0.00218"

  Scenario Outline: N2O emission factor from egrid subregion
    Given a characteristic "egrid_subregion.abbreviation" of "<subregion>"
    When the "n2o_emission_factor" committee reports
    Then the committee should have used quorum "from eGRID subregion"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | subregion | ef    |
      | SRVC      | 0.003 |
      | CAMX      | 0.001 |

  Scenario: CH4 emission factor from default
    When the "egrid_subregion" committee reports
    And the "ch4_emission_factor" committee reports
    Then the committee should have used quorum "from eGRID subregion"
    And the conclusion of the committee should be "0.00030"

  Scenario Outline: CH4 emission factor from egrid subregion
    Given a characteristic "egrid_subregion.abbreviation" of "<subregion>"
    When the "ch4_emission_factor" committee reports
    Then the committee should have used quorum "from eGRID subregion"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | subregion | ef     |
      | SRVC      | 0.0003 |
      | CAMX      | 0.0003 |

  Scenario: CO2 biogenic emission factor from default
    When the "egrid_subregion" committee reports
    And the "co2_biogenic_emission_factor" committee reports
    Then the committee should have used quorum "from eGRID subregion"
    And the conclusion of the committee should be "0.0"

  Scenario Outline: CO2 biogenic emission factor from egrid subregion
    Given a characteristic "egrid_subregion.abbreviation" of "<subregion>"
    When the "co2_biogenic_emission_factor" committee reports
    Then the committee should have used quorum "from eGRID subregion"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | subregion | ef  |
      | SRVC      | 0.0 |
      | CAMX      | 0.0 |

  Scenario: CO2 emission factor from default
    When the "egrid_subregion" committee reports
    And the "co2_emission_factor" committee reports
    Then the committee should have used quorum "from eGRID subregion"
    And the conclusion of the committee should be "0.41751"

  Scenario Outline: CO2 emission factor from egrid subregion
    Given a characteristic "egrid_subregion.abbreviation" of "<subregion>"
    When the "co2_emission_factor" committee reports
    Then the committee should have used quorum "from eGRID subregion"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | subregion | ef  |
      | SRVC      | 0.5 |
      | CAMX      | 0.3 |

  Scenario: N2O emission from electricity use, n2o emission factor, and default date
    Given a characteristic "electricity_use" of "10.0"
    And a characteristic "n2o_emission_factor" of "2.0"
    And a characteristic "timeframe" of "2010-01-01/2011-01-01"
    When the "date" committee reports
    And the "n2o_emission" committee reports
    Then the committee should have used quorum "from electricity use, n2o emission factor, date, and timeframe"
    And the conclusion of the committee should be "20.0"

  Scenario Outline: N2O emission from electricity use, n2o emission factor, date, and timeframe
    Given a characteristic "electricity_use" of "10.0"
    And a characteristic "n2o_emission_factor" of "2.0"
    And a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "n2o_emission" committee reports
    Then the committee should have used quorum "from electricity use, n2o emission factor, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | date       | timeframe             | emission |
      | 2010-06-01 | 2010-01-01/2011-01-01 | 20.0     |
      | 2009-06-01 | 2010-01-01/2011-01-01 |  0.0     |

  Scenario: CH4 emission from electricity use, ch4 emission factor, and default date
    Given a characteristic "electricity_use" of "10.0"
    And a characteristic "ch4_emission_factor" of "2.0"
    And a characteristic "timeframe" of "2010-01-01/2011-01-01"
    When the "date" committee reports
    And the "ch4_emission" committee reports
    Then the committee should have used quorum "from electricity use, ch4 emission factor, date, and timeframe"
    And the conclusion of the committee should be "20.0"

  Scenario Outline: CH4 emission from electricity use, ch4 emission factor, date, and timeframe
    Given a characteristic "electricity_use" of "10.0"
    And a characteristic "ch4_emission_factor" of "2.0"
    And a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "ch4_emission" committee reports
    Then the committee should have used quorum "from electricity use, ch4 emission factor, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | date       | timeframe             | emission |
      | 2010-06-01 | 2010-01-01/2011-01-01 | 20.0     |
      | 2009-06-01 | 2010-01-01/2011-01-01 |  0.0     |

  Scenario: CO2 biogenic emission from electricity use, co2 biogenic emission factor, and default date
    Given a characteristic "electricity_use" of "10.0"
    And a characteristic "co2_biogenic_emission_factor" of "2.0"
    And a characteristic "timeframe" of "2010-01-01/2011-01-01"
    When the "date" committee reports
    And the "co2_biogenic_emission" committee reports
    Then the committee should have used quorum "from electricity use, co2 biogenic emission factor, date, and timeframe"
    And the conclusion of the committee should be "20.0"

  Scenario Outline: CO2 biogenic emission from electricity use, co2 biogenic emission factor, date, and timeframe
    Given a characteristic "electricity_use" of "10.0"
    And a characteristic "co2_biogenic_emission_factor" of "2.0"
    And a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "co2_biogenic_emission" committee reports
    Then the committee should have used quorum "from electricity use, co2 biogenic emission factor, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | date       | timeframe             | emission |
      | 2010-06-01 | 2010-01-01/2011-01-01 | 20.0     |
      | 2009-06-01 | 2010-01-01/2011-01-01 |  0.0     |

  Scenario: CO2 emission from electricity use, co2 emission factor, and default date
    Given a characteristic "electricity_use" of "10.0"
    And a characteristic "co2_emission_factor" of "2.0"
    And a characteristic "timeframe" of "2010-01-01/2011-01-01"
    When the "date" committee reports
    And the "co2_emission" committee reports
    Then the committee should have used quorum "from electricity use, co2 emission factor, date, and timeframe"
    And the conclusion of the committee should be "20.0"

  Scenario Outline: CO2 emission from electricity use, co2 emission factor, date, and timeframe
    Given a characteristic "electricity_use" of "10.0"
    And a characteristic "co2_emission_factor" of "2.0"
    And a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "co2_emission" committee reports
    Then the committee should have used quorum "from electricity use, co2 emission factor, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | date       | timeframe             | emission |
      | 2010-06-01 | 2010-01-01/2011-01-01 | 20.0     |
      | 2009-06-01 | 2010-01-01/2011-01-01 |  0.0     |
