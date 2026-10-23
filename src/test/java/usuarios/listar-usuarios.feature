Feature: GET /usuarios - Listar usuarios

  Background:
    * url urlBase
    * def esquemaLista = read('classpath:esquemas/lista-usuarios.json')
    * def esquemaUsuario = read('classpath:esquemas/usuario.json')

  @happy
  Scenario: Listar todos los usuarios
    Given path 'usuarios'
    When method get
    Then status 200
    And match response == esquemaLista
    And match each response.usuarios == esquemaUsuario
    And match response.quantidade == response.usuarios.length

  @happy
  Scenario: Filtrar usuarios por email existente
    * def creado = call read('classpath:helpers/crear-usuario.feature')
    * configure afterScenario = function(){ karate.call('classpath:helpers/eliminar-usuario.feature', { idUsuario: creado.idUsuario }) }
    Given path 'usuarios'
    And param email = creado.usuario.email
    When method get
    Then status 200
    And match response.quantidade == 1
    And match response.usuarios[0] == esquemaUsuario
    And match response.usuarios[0]._id == creado.idUsuario

  @unhappy
  Scenario: Filtrar por un email que no existe devuelve lista vacia
    Given path 'usuarios'
    And param email = 'no_existe_' + java.util.UUID.randomUUID() + '@test.com'
    When method get
    Then status 200
    And match response == { quantidade: 0, usuarios: [] }

  @unhappy
  Scenario: Filtrar con un valor invalido de administrador
    Given path 'usuarios'
    And param administrador = 'talvez'
    When method get
    Then status 400
    And match response == { administrador: "administrador deve ser 'true' ou 'false'" }
