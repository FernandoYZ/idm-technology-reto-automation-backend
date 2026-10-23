Feature: PUT /usuarios/{_id} - Actualizar usuario

  Background:
    * url urlBase
    * def creado = call read('classpath:helpers/crear-usuario.feature')
    * def idsCreados = [ '#(creado.idUsuario)' ]
    * configure afterScenario = function(){ idsCreados.forEach(function(id){ karate.call('classpath:helpers/eliminar-usuario.feature', { idUsuario: id }) }) }
    * def datosNuevos = call read('classpath:helpers/datos.js')

  @happy
  Scenario: Actualizar un usuario existente
    * datosNuevos.administrador = 'false'
    Given path 'usuarios', creado.idUsuario
    And request datosNuevos
    When method put
    Then status 200
    And match response == { message: 'Registro alterado com sucesso' }

    Given path 'usuarios', creado.idUsuario
    When method get
    Then status 200
    And match response contains datosNuevos

  @unhappy
  Scenario: No se puede actualizar con el email de otro usuario
    * def otro = call read('classpath:helpers/crear-usuario.feature')
    * idsCreados.push(otro.idUsuario)
    * datosNuevos.email = otro.usuario.email
    Given path 'usuarios', creado.idUsuario
    And request datosNuevos
    When method put
    Then status 400
    And match response == { message: 'Este email já está sendo usado' }

  @unhappy
  Scenario: No se puede actualizar con el nombre vacio
    * datosNuevos.nome = ''
    Given path 'usuarios', creado.idUsuario
    And request datosNuevos
    When method put
    Then status 400
    And match response == { nome: 'nome não pode ficar em branco' }

  @unhappy
  Scenario: Actualizar un ID inexistente registra un usuario nuevo (comportamiento documentado de la API)
    Given path 'usuarios', '0000000000000000'
    And request datosNuevos
    When method put
    Then status 201
    And match response == read('classpath:esquemas/usuario-creado.json')
    * idsCreados.push(response._id)
