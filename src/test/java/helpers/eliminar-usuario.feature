@ignore
Feature: Helper - eliminar un usuario por id

  Scenario:
    Given url urlBase
    And path 'usuarios', idUsuario
    When method delete
    Then status 200
