Feature: POST /usuarios - Registrar usuario

  Background:
    * url urlBase
    * path 'usuarios'
    * def usuario = call read('classpath:helpers/datos.js')

  @happy
  Scenario: Registrar un usuario con datos validos
    Given request usuario
    When method post
    Then status 201
    And match response == read('classpath:esquemas/usuario-creado.json')
    * call read('classpath:helpers/eliminar-usuario.feature') { idUsuario: '#(response._id)' }

  @unhappy
  Scenario: No se puede registrar un usuario con un email ya usado
    * def creado = call read('classpath:helpers/crear-usuario.feature')
    * configure afterScenario = function(){ karate.call('classpath:helpers/eliminar-usuario.feature', { idUsuario: creado.idUsuario }) }
    * usuario.email = creado.usuario.email
    Given request usuario
    When method post
    Then status 400
    And match response == { message: 'Este email já está sendo usado' }

  @unhappy
  Scenario Outline: No se puede registrar con <campo> invalido: "<valor>"
    * karate.set('usuario', '$.<campo>', '<valor>')
    Given request usuario
    When method post
    Then status 400
    And match response == { <campo>: "<mensaje>" }

    Examples:
      | campo         | valor      | mensaje                                   |
      | nome          |            | nome não pode ficar em branco             |
      | email         |            | email não pode ficar em branco            |
      | email         | correo.com | email deve ser um email válido            |
      | password      |            | password não pode ficar em branco         |
      | administrador | si         | administrador deve ser 'true' ou 'false'  |

  @unhappy
  Scenario Outline: No se puede registrar sin el campo obligatorio <campo>
    * karate.remove('usuario', '$.<campo>')
    Given request usuario
    When method post
    Then status 400
    And match response == { <campo>: '<campo> é obrigatório' }

    Examples:
      | campo         |
      | nome          |
      | email         |
      | password      |
      | administrador |
