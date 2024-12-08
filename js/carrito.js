    var carritoVisible = false;
    var totalFinal = 0;
    var pagarButton = document.getElementById("pagar");
    var miArrayList = [];

    if(document.readyState == 'loading'){
        document.addEventListener('DOMContentLoaded', ready)
    }else{
        ready();
    }

    function ready(){
        
        //botones eliminar del carrito
        var botonesEliminarItem = document.getElementsByClassName('btn-eliminar');
        for(var i=0;i<botonesEliminarItem.length; i++){
            var button = botonesEliminarItem[i];
            button.addEventListener('click',eliminarItemCarrito);
        }

        //boton sumar cantidad
        var botonesSumarCantidad = document.getElementsByClassName('sumar-cantidad');
        for(var i=0;i<botonesSumarCantidad.length; i++){
            var button = botonesSumarCantidad[i];
            button.addEventListener('click',sumarCantidad);
        }

        //boton restar cantidad
        var botonesRestarCantidad = document.getElementsByClassName('restar-cantidad');
        for(var i=0;i<botonesRestarCantidad.length; i++){
            var button = botonesRestarCantidad[i];
            button.addEventListener('click',restarCantidad);
        }

        //boton agregar al carrito
        var botonesAgregarAlCarrito = document.getElementsByClassName('boton-item');
        for(var i=0; i<botonesAgregarAlCarrito.length;i++){
            var button = botonesAgregarAlCarrito[i];
            button.addEventListener('click', agregarAlCarritoClicked);
        }

        //botón comprar
        document.getElementsByClassName('btn-pagar')[0].addEventListener('click',pagarClicked)
    }
    //eliminar todos los elementos del carrito y lo ocultamos
    function pagarClicked(){
        //eliminar todos los elmentos del carrito
        var carritoItems = document.getElementsByClassName('carrito-items')[0];
        var productosCarrito = [];

        while (carritoItems.hasChildNodes()){
            carritoItems.removeChild(carritoItems.firstChild)
        }
        actualizarTotalCarrito();
        ocultarCarrito();
    }
    function agregarAlCarritoClicked(event){
        var button = event.target;
        var item = button.parentElement;
        var titulo = item.getElementsByClassName('titulo-item')[0].innerText;
        var precio = item.getElementsByClassName('precio-item')[0].innerText;
        var imagenSrc = item.getElementsByClassName('img-item')[0].src;
        var idS = item.getAttribute("data-id");
        var cantidadS = item.getAttribute("data-cantidad");
        console.log(imagenSrc);

        agregarItemAlCarrito(titulo, precio, imagenSrc, idS, cantidadS);

        hacerVisibleCarrito();
    }

    //funcion visible el carrito
    function hacerVisibleCarrito(){
        carritoVisible = true;
        var carrito = document.getElementsByClassName('carrito')[0];
        carrito.style.marginRight = '0';
        carrito.style.opacity = '1';

        var items =document.getElementsByClassName('contenedor-items')[0];
        items.style.width = '60%';
    }

    //funcion que agrega un item al carrito
    function agregarItemAlCarrito(titulo, precio, imagenSrc, idS, cantidadS){
        var item = document.createElement('div');
        item.classList.add = ('item');
        var itemsCarrito = document.getElementsByClassName('carrito-items')[0];

        //var idProducto = item.getAttribute('data-id');
        miArrayList.push(idS);

        //controlamos que el item que intenta ingresar no se encuentre en el carrito
        var nombresItemsCarrito = itemsCarrito.getElementsByClassName('carrito-item-titulo');
        for(var i=0;i < nombresItemsCarrito.length;i++){
            if(nombresItemsCarrito[i].innerText==titulo){
                alert("El item ya se encuentra en el carrito");
                return;
            }
        }

        var itemCarritoContenido = `
            <div class="carrito-item" data-cantidad-C=${cantidadS} data-id-C="${idS}">
                <img src="${imagenSrc}" width="80px" alt="">
                <div class="carrito-item-detalles">
                    <span class="carrito-item-titulo">${titulo}</span>
                    <div class="selector-cantidad">
                        <i class="fa-solid fa-minus restar-cantidad"></i>
                        <input type="text" value="1" class="carrito-item-cantidad" disabled>
                        <i class="fa-solid fa-plus sumar-cantidad"></i>
                    </div>
                    <span class="carrito-item-precio">${precio}</span>
                </div>
                <button class="btn-eliminar">
                    <i class="fa-solid fa-trash"></i>
                </button>
            </div>
        `
        item.innerHTML = itemCarritoContenido;
        itemsCarrito.append(item);

        //funcionalidad eliminar al nuevo item
        item.getElementsByClassName('btn-eliminar')[0].addEventListener('click', eliminarItemCarrito);

        //funcionalidad restar cantidad del nuevo item
        var botonRestarCantidad = item.getElementsByClassName('restar-cantidad')[0];
        botonRestarCantidad.addEventListener('click',restarCantidad);

        //funcionalidad sumar cantidad del nuevo item
        var botonSumarCantidad = item.getElementsByClassName('sumar-cantidad')[0];
        botonSumarCantidad.addEventListener('click',sumarCantidad);

        //total
        actualizarTotalCarrito();
    }
    //aumenta en uno la cantidad del elemento seleccionado
    function sumarCantidad(event){
        var buttonClicked = event.target;
        var selector = buttonClicked.parentElement;
        //obtener cantidad de elementos
        var cantidadElement = selector.getElementsByClassName('carrito-item-cantidad')[0];
        console.log(selector.getElementsByClassName('carrito-item-cantidad')[0].value);

        var cantidadActual = selector.getElementsByClassName('carrito-item-cantidad')[0].value;
        cantidadActual++;
        //actualizar cantidad
        cantidadElement.dataset.cantidad = cantidadActual;
        console.log("cantidad console: ", cantidadActual);
        //console.log("cantidad data-: ", getAttribute("data-cantidad"));
        selector.getElementsByClassName('carrito-item-cantidad')[0].value = cantidadActual;
        actualizarTotalCarrito();   
    }
    //resta en uno la cantidad del elemento seleccionado
    function restarCantidad(event){ 
        var buttonClicked = event.target;
        var selector = buttonClicked.parentElement;
        //obtener cantidad de elementos
        var cantidadElement = selector.getElementsByClassName('carrito-item-cantidad')[0];
        console.log(selector.getElementsByClassName('carrito-item-cantidad')[0].value);
        
        var cantidadActual = selector.getElementsByClassName('carrito-item-cantidad')[0].value;
        cantidadActual--;
        if(cantidadActual>=1){
            //actualizar cantidad
            cantidadElement.dataset.cantidad = cantidadActual;
            console.log("cantidad: ", cantidadActual);
            selector.getElementsByClassName('carrito-item-cantidad')[0].value = cantidadActual;
            /*const p = cantidadElement.parentNode;
            const a = p.parentNode;
            const idPr = a.getAttribute('data-id');
            const elemento = document.querySelector(`[data-id="${idPr}"]`);
            elemento.setAttribute('data-cantidad', cantidadActual);
            console.log("ACT: ", elemento.getAttribute('data-cantidad'));*/
            actualizarTotalCarrito();
        }
    }

    //eliminar el item seleccionado del carrito
    function eliminarItemCarrito(event){
        var buttonClicked = event.target;
        var carritoItem = buttonClicked.closest('.carrito-item'); // Obtener el elemento del carrito más cercano
        var idProductoEliminar = carritoItem.getAttribute('data-id-C');
        var index = miArrayList.indexOf(idProductoEliminar);
        if (index !== -1) {
            miArrayList.splice(index, 1);
        }
        carritoItem.remove();
        //actualizar el total del carrito
        actualizarTotalCarrito();
    
        //oculta si el carrito esta vacio
        ocultarCarrito();
    }

    function ocultarCarrito(){
        var carritoItems = document.getElementsByClassName('carrito-items')[0];
        if(carritoItems.childElementCount==0){
            var carrito = document.getElementsByClassName('carrito')[0];
            carrito.style.marginRight = '-100%';
            carrito.style.opacity = '0';
            carritoVisible = false;
        
            var items =document.getElementsByClassName('contenedor-items')[0];
            items.style.width = '100%';
            miArrayList = [];
        }
    }

    //actualiza el total de Carrito
    function actualizarTotalCarrito() {
        var carritoContenedor = document.getElementsByClassName('carrito')[0];
        var carritoItems = carritoContenedor.getElementsByClassName('carrito-item');
        var total = 0;

        for (var i = 0; i < carritoItems.length; i++) {
            var item = carritoItems[i];
            var precioElemento = item.getElementsByClassName('carrito-item-precio')[0];
            var precio = parseFloat(precioElemento.innerText.replace('s/.', '').replace(',', ''));
            var cantidadItem = item.getElementsByClassName('carrito-item-cantidad')[0];
            var cantidad = parseFloat(cantidadItem.value); 
            //var prodContainer = document.getElementById("productos-container");
            
            /*var dataId = item.getAttribute("data-id");
            var elementProd = prodContainer.querySelector('[data-id="' + dataId + '"]');
            elementProd.dataset.id = cantidad;
            console.log("cantidad carro_: ", cantidad);*/

            total += precio * cantidad;
        }

        total = total.toFixed(2); // Mantener dos decimales
        totalFinal = total;
        var valorBotonPagar = "Total: " + totalFinal + ", Elementos: " + miArrayList.join(", ");
        pagarButton.value = valorBotonPagar;
        console.log("Costo... ", total, "valor: ", pagarButton.value);
        document.getElementsByClassName('carrito-precio-total')[0].innerText = 's/.' + total.toLocaleString("es");
    }