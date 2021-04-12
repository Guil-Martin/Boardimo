// Input
var content = document.getElementById("test");
var btnScan = document.getElementById("scan");
btnScan.addEventListener("click", function(e) {

    fetch('http://localhost:7373/api_index')
    .then(response => response.json())
    .then(data => {

        console.log(data["houses"])

        for (let index = 0; index < data["houses"].length; index++) {
            content.innerHTML += "<p>"+ data["houses"][index]["link"] + "</p>"      
            
            







            
        }

        // // List of available products in an option select
        // for (let [key, value] of Object.entries(data.product_list)) {
        //     console.log(`${key}: ${value}`);
        //     select.innerHTML += "<option value="+ key +">"+key+"</option>"
        // }
        // // CREATE FRUIT CARDS

        // // Displays list of products in current cart
        // list.innerHTML = null;
        // for (let [key, value] of Object.entries(data.cart_list)) {
        //     list.innerHTML += "<p value="+ value +">"+ value + "</p>"
        // }
        // total.innerHTML = data.cart_total + " €"

        // let btns = document.querySelectorAll('.fruitCard');
        // console.log(btns)
        // // adding the event listener by looping
        // btns.forEach(el => {
        //     console.log(el)
        //     el.addEventListener('click', (e) => {
        //         console.log(e.currentTarget.value);
        //     });
        // });

    })
    .catch((error) => {
        console.error('Error:', error);
    });

});