Feature: Push Gems
  In order to share code with the world
  A rubygem developer
  Should be able to push gems up to Gemcutter

  Scenario: User pushes new gem
    Given I am signed up as "email@person.com"
    And I have a gem "rgem" with version "1.2.3"
    And I have an API key for "email@person.com/password"
    When I push the gem "rgem-1.2.3.gem" with my API key
    And I visit the gem page for "rgem"
    Then I should see "rgem"
    And I should see "1.2.3"

  Scenario: User pushes existing version of existing gem
    Given I am signed up as "email@person.com"
    And I have a gem "pgem" with version "1.0.0" and summary "First try"
    And I have an API key for "email@person.com/password"
    When I push the gem "pgem-1.0.0.gem" with my API key
    And I visit the gem page for "pgem"
    Then I should see "pgem"
    And I should see "1.0.0"
    And I should see "First try"

    When I have a gem "pgem" with version "1.0.0" and summary "Second try"
    And I push the gem "pgem-1.0.0.gem" with my API key
    Then the response should contain "Repushing of gem versions is not allowed."
    And the response should contain "Please use `gem yank` to remove bad gem releases."
    And I visit the gem page for "pgem"
    And I should see "pgem"
    And I should see "1.0.0"
    And I should see "First try"

  Scenario: User pushes new version of existing gem
    Given I am signed up as "email@person.com"
    And I have an API key for "email@person.com/password"
    And I have a gem "bgem" with version "2.0.0"
    And I push the gem "bgem-2.0.0.gem" with my API key
    And I have a gem "bgem" with version "3.0.0"
    When I push the gem "bgem-3.0.0.gem" with my API key
    And I visit the gem page for "bgem"
    Then I should see "bgem"
    And I should see "2.0.0"
    And I should see "3.0.0"

  Scenario: User pushes gem with bad url
    Given I am signed up as "email@person.com"
    And I have an API key for "email@person.com/password"
    And I have a gem "badurl" with version "1.0.0" and homepage "badurl.com"
    When I push the gem "badurl-1.0.0.gem" with my API key
    Then I should see "Home does not appear to be a valid URL"

  Scenario: User pushes gem with bad name
    Given I am signed up as "email@person.com"
    And I have an API key for "email@person.com/password"
    And I have a bad gem "true" with version "1.0.0"
    When I push the gem "true-1.0.0.gem" with my API key
    Then I should see "Name must be a String"

  Scenario: User pushes gem with bad authors
    Given I am signed up as "email@person.com"
    And I have an API key for "email@person.com/password"
    And I have a gem "badauthors" with version "1.0.0" and authors "[3]"
    When I push the gem "badauthors-1.0.0.gem" with my API key
    Then I should see "Authors must be an Array of Strings"

  Scenario: User pushes gem with unknown runtime dependency
    Given I am signed up as "email@person.com"
    And I have an API key for "email@person.com/password"
    And I have a gem "unkdeps" with version "1.0.0" and runtime dependency "unknown"
    When I push the gem "unkdeps-1.0.0.gem" with my API key
    And I visit the gem page for "unkdeps"
    Then I should see "unkdeps"
    And I should see "1.0.0"

  @wip
  Scenario: User pushes gem with missing :rubygems_version, :specification_version, :name, :version, :date, :summary, :require_paths

  Scenario: User pushes file that is not a gem
    Given I am signed up as "email@person.com"
    And I have an API key for "email@person.com/password"
    When I push an invalid .gem file
    Then I should see "RubyGems.org cannot process this gem."
    And I should not see "Error:"
    And I should not see "No metadata found!"
