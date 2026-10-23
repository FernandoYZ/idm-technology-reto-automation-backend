function fn() {
  var config = {
    urlBase: karate.properties['urlBase'] || 'https://serverest.dev'
  };
  karate.configure('connectTimeout', 10000);
  karate.configure('readTimeout', 10000);
  return config;
}
