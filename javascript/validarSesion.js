// validarSesion.js

// Obtener el valor de una cookie por su nombre
function getCookie(name) {
    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);
    if (parts.length === 2) return parts.pop().split(';').shift();
    return null;
}

// Validar sesión
function validarSesion(tipoRequerido) {
    const tipoUsuario = getCookie("tipo_usuario");
    const nombreUsuario = getCookie("nombre_usuario");

    // Verificar si el tipo de usuario es válido
    if (!tipoUsuario || tipoUsuario !== tipoRequerido) {
        alert("Acceso denegado. Debes iniciar sesión como " + tipoRequerido + ".");
        window.location.href = "/login.html";
        throw new Error("Acceso denegado"); // Detener ejecución del script
    }

    // Verificar si hay un usuario logueado
    if (!nombreUsuario) {
        alert("Sesión inválida. Debes iniciar sesión nuevamente.");
        window.location.href = "/login.html";
        throw new Error("Sesión inválida"); // Detener ejecución del script
    }
}
