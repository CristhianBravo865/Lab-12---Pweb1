document.addEventListener('DOMContentLoaded', function() {
    // Obtener el formulario y el campo de error
    const form = document.getElementById('form-login');
    const errorLoginLabel = document.getElementById('errorLogin');
    
    // Verificar si existe el parámetro de error en la URL (lo pasa Perl al redirigir)
    const urlParams = new URLSearchParams(window.location.search);
    const error = urlParams.get('error');

    if (error === '1') {
        errorLoginLabel.style.color = 'red';
        errorLoginLabel.textContent = 'Credenciales incorrectas. Intenta nuevamente.';
    }

    form.addEventListener('submit', function(event) {
        const username = form.querySelector('input[name="login_usuario"]').value;
        const password = form.querySelector('input[name="password"]').value;

        if (!username || !password) {
            event.preventDefault();  // Evitar el envío si no hay datos
            errorLoginLabel.style.color = 'red';
            errorLoginLabel.textContent = 'Por favor ingresa todos los campos.';
        }
    });
});
