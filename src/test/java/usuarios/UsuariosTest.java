package usuarios;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class UsuariosTest {

    @Test
    void ejecutarPruebasDeUsuarios() {
        Results resultados = Runner.path("classpath:usuarios").parallel(4);
        assertEquals(0, resultados.getFailCount(), resultados.getErrorMessages());
    }
}
