Feature: DELETE /usuarios/{_id} - Eliminar usuario

  Background:
    * url urlBase

  @happy
  Scenario: Eliminar un usuario existente
    * def creado = call read('classpath:helpers/crear-usuario.feature')
    Given path 'usuarios', creado.idUsuario
    When method delete
    Then status 200
    And match response == { message: 'Registro excluído com sucesso' }

    Given path 'usuarios', creado.idUsuario
    When method get
    Then status 400
    And match response.message == 'Usuário não encontrado'

  @unhappy
  Scenario: Eliminar un ID que no existe
    Given path 'usuarios', '0000000000000000'
    When method delete
    Then status 200
    And match response == { message: 'Nenhum registro excluído' }

  @unhappy
  Scenario: No se puede eliminar un usuario con carrito registrado
    * def creado = call read('classpath:helpers/crear-usuario.feature')

    Given path 'login'
    And request { email: '#(creado.usuario.email)', password: '#(creado.usuario.password)' }
    When method post
    Then status 200
    * def token = response.authorization

    Given path 'produtos'
    When method get
    Then status 200
    * def producto = karate.filter(response.produtos, function(p){ return p.quantidade > 0 })[0]

    Given path 'carrinhos'
    And header Authorization = token
    And request { produtos: [ { idProduto: '#(producto._id)', quantidade: 1 } ] }
    When method post
    Then status 201

    Given path 'usuarios', creado.idUsuario
    When method delete
    Then status 400
    And match response contains { message: 'Não é permitido excluir usuário com carrinho cadastrado' }

    Given path 'carrinhos', 'cancelar-compra'
    And header Authorization = token
    When method delete
    Then status 200
    * call read('classpath:helpers/eliminar-usuario.feature') { idUsuario: '#(creado.idUsuario)' }
