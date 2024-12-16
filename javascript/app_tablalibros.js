function showModal() {
    var modal = document.getElementById('modal');
    modal.style.display = "block";
}

function closeModal() {
    var modal = document.getElementById('modal');
    modal.style.display = "none";
}

document.addEventListener("DOMContentLoaded", function () {
    try {
        // Validar sesión como propietario
        validarSesion("propietario");

        // Cargar libros desde el servidor
        const tableBody = document.querySelector("#libros-table tbody");
        fetch("/cgi-bin/tablalibros.pl")
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Error al cargar los datos del servidor");
                }
                return response.json();
            })
            .then((data) => renderTable(data))
            .catch((err) => {
                console.error("Error al cargar libros:", err);
                alert("Hubo un problema al cargar los libros. Inténtalo nuevamente más tarde.");
            });

        // Renderizar los libros en la tabla
        function renderTable(libros) {
            if (libros.length === 0) {
                const row = document.createElement("tr");
                row.innerHTML = `<td colspan="5">No hay libros disponibles</td>`;
                tableBody.appendChild(row);
                return;
            }

            libros.forEach((libro) => {
                const row = document.createElement("tr");
                row.innerHTML = `
                    <td>${libro.id}</td>
                    <td>${libro.nombre}</td>
                    <td>${libro.descripcion}</td>
                    <td><img src="/images/${libro.imagen}" alt="${libro.nombre}" width="50"></td>
                    <td>${libro.precio}</td>
                `;
                tableBody.appendChild(row);
            });
        }
        // Mostrar modal
        window.showModal = function () {
            var modal = document.getElementById('modal');
            modal.style.display = "block";
        };

        // Cerrar modal
        window.closeModal = function () {
            var modal = document.getElementById('modal');
            modal.style.display = "none";
        };

        // Agregar libro
        document.getElementById("guardar-libro-btn").addEventListener("click", function () {
            const form = document.getElementById("agregar-libro-form");
            const formData = new FormData(form);

            fetch("/cgi-bin/agregarlibro.pl", {
                method: "POST",
                body: formData,
            })
                .then((response) => {
                    if (!response.ok) {
                        throw new Error("Error al enviar el formulario");
                    }
                    return response.json();
                })
                .then((data) => {
                    if (data.success) {
                        alert("Libro agregado con éxito");
                        window.location.reload();
                    } else {
                        alert("Error al agregar libro: " + data.error);
                    }
                })
                .catch((err) => {
                    console.error("Error al enviar formulario:", err);
                    alert("Hubo un problema al agregar el libro. Inténtalo nuevamente más tarde.");
                });
        });
    } catch (error) {
        console.error(error.message);
    }
});
