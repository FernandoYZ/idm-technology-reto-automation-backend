@ignore
Feature: Helper - crear un usuario y devolver su id

  Scenario:
    * def usuario = call read('classpath:helpers/datos.js')
    Given url urlBase
    And path 'usuarios'
    And request usuario
    When method post
    Then status 201
    * def idUsuario = response._id
