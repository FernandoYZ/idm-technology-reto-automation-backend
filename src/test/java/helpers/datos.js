function() {
  var aleatorio = java.util.UUID.randomUUID().toString().substring(0, 8);
  return {
    nome: 'QA Usuario ' + aleatorio,
    email: 'qa_' + aleatorio + '@test.com',
    password: 'clave' + aleatorio,
    administrador: 'true'
  };
}
