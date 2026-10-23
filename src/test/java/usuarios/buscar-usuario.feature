Feature: GET /usuarios/{_id} - Buscar usuario por ID

  Background:
    * url urlBase

  @happy
  Scenario: Buscar un usuario existente por su ID
    * def creado = call read('classpath:helpers/crear-usuario.feature')
    * configure afterScenario = function(){ karate.call('classpath:helpers/eliminar-usuario.feature', { idUsuario: creado.idUsuario }) }
    Given path 'usuarios', creado.idUsuario
    When method get
    Then status 200
    And match response == read('classpath:esquemas/usuario.json')
    And match response contains creado.usuario
    And match response._id == creado.idUsuario

  @unhappy
  Scenario: Buscar un ID valido que no existe
    Given path 'usuarios', '0000000000000000'
    When method get
    Then status 400
    And match response == { message: 'Usuário não encontrado' }

  @unhappy
  Scenario: Buscar con un ID de formato invalido
    Given path 'usuarios', '123'
    When method get
    Then status 400
    And match response == { id: 'id deve ter exatamente 16 caracteres alfanuméricos' }
