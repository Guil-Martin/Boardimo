// Scan
var scanInput = document.getElementById("scanInput");
var btnScan = document.getElementById("scan");
var result = document.getElementById("results")
var analyse = document.getElementById("analyse")
btnScan.addEventListener("click", function(e) {

    fetch('http://localhost:7373/api_scan', {
        method: 'POST',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'plain/text;charset=UTF-8',
        },
        body: JSON.stringify({link: scanInput.value}),
    })
    .then(response => response.json())
    .then(data => {
        console.log(data)

        result.innerHTML = `
            <div class="flex-none w-48 relative">
                <img src="${data["house"]["img"]}" alt="" class="absolute inset-0 w-full h-full object-cover" />
            </div>
            <form class="flex-auto p-6">
                <div class="flex flex-wrap">
                    <h1 class="flex-auto text-xl font-semibold">
                        ${data["house"]["name"]}
                    </h1>
                    <div class="text-xl font-semibold text-gray-500">
                        ${data["house"]["price"]}
                    </div>
                </div>

                <div class="divide-y divide-fuchsia-300">
                    <div>
                        <span class="badge bg-primary">${data["house"]["surface"]}</span>   
                        <span class="badge bg-primary">${data["house"]["year"]}</span> 
                        <span class="badge bg-d">${data["house"]["energetics"]}</span>
                    </div>
                    <br>
                    <div class="bottom-divide">
                        Prix par m² <span class="price">${data["stats"]["price_sqm"]}</span>
                    </div>
                </div>
            </form>
            `;

            // Price comparison //
            let priceSqmPercent = data["stats"]["price_sqm_compare"];
            let priceBG = price_bg(priceSqmPercent);
            let priceGood = priceSqmPercent > 100;
            priceSqmPercent = percent(priceSqmPercent);
            ////

            // Year comparison //
            let year_compare = data["stats"]["year_compare"];
            let yearDiff = data["house"]["year"] - data["stats"]["year_average"]
            let yearBG = year_bg(data["stats"]["renovation_cost"]["oldness"]);
            let extraCostYear = data["stats"]["renovation_cost"]["extra_cost"] 
            let renov = data["stats"]["renovation_cost"]["renov"]
            let avg_less = data["stats"]["renovation_cost"]["avg_less"]      
            ////

            // Energetics //
            let energetics = data["house"]["energetics"];
            let energeticsBG = energetics_BG(energetics);
            let energeticsCompare = percent(data["stats"]["energetics_compare"]);
            let extraCostEnergetics = extraCostYear
            ////           
            
            let realSqmPrice = (data["stats"]["price_sqm_raw"] + extraCostYear + extraCostEnergetics)            
            realSqmPrice = realSqmPrice / 10 | 0
            let realSqmPriceBG = real_sqm_price_bg(data["stats"]["price_sqm_raw"], realSqmPrice);

            analyse.innerHTML = `
            <h2>Analyse du bien</h2>
            <div class="alert ${priceBG} " role="alert">
                <h4 class="alert-heading">Prix du bien</h4>
                <p>À ${data["house"]["cityName"]}, le prix moyen d'une maison au m² est de <b>${data["stats"]["price_sqm_city"]}</b> soit ${priceSqmPercent}% ${priceGood ? "inférieur" : "supérieur"}  au prix de ce bien.</p>
            </div>
            <div class="alert ${yearBG}" role="alert">
                <h4 class="alert-heading">Année de construction</h4>
                <p>Cette maison <b>est plus récente que ${year_compare}%</b> des maisons en vente actuellement et a en moyenne <b>${yearDiff > 0 ? yearDiff + " ans de moins que la concurrence" : -yearDiff + " ans de plus que la concurrence"} </b></p>
                <hr>
                <p class="mb-0">Suite à un achat de ce type, un acquereur dépensera en moyenne <b>${renov} de rénovations en tout genre</b> soit <b>${avg_less < 0 ? -avg_less + " de plus" : avg_less + " de moins"}</b> que la moyenne pour cette surface</p>
            </div>
            <div class="alert ${energeticsBG}" role="alert">
                <h4 class="alert-heading">Classe énergie</h4>
                <p>Cette maison a une <b>classe énergétique ${energetics}</b> ce qui est moins bien que ${energeticsCompare}% des maisons en vente actuellement</b></p>
                <hr>
                <p class="mb-0">Le surcoût énergétique par m2 est estimé à 30.4€</b> 
                </p>
            </div>
            <div class="alert ${realSqmPriceBG}" role="alert">
                <h4 class="alert-heading">Estimation</h4>
                <p>En prenant en compte l'année de construction, la localisation et le prix au m2 nous pensons que cette maison est ${realSqmPriceBG == "bg-e" || realSqmPriceBG == "bg-g" ? "surévaluée" : "honnête"}.</p>
                <hr>
                <p class="mb-0">Afin de correspondre au prix du marché nous évaluons que le prix de ce bien devrait se situer entre <b>${realSqmPrice * 0.9}k€</b> et <b>${realSqmPrice * 1.1}k€</b></p>
            </div>
            `

        // update content
    })
    .catch(error => {
        console.error('Error:', error);
    });

});

var linksEnable = document.getElementById("linksEnable"); 
var linksContainer = document.getElementsByClassName("links")[0]; 
linksEnable.addEventListener("click", function(e) {

    e.currentTarget.disabled = true;

    fetch('http://localhost:7373/api_links', {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'plain/text;charset=UTF-8',
        }
    })    
    .then(response => response.json())
    .then(data => {

        linksContainer.innerHTML = ""

        console.log(data)

        for (let index = 0; index < data["links"].length; index++) {
            linksContainer.innerHTML +=     
            `
            <button value="${data["links"][index]}" class="linkBtn">M</button>
            `
        }

        var buttons = linksContainer.querySelectorAll('.linkBtn');
        for (var i = 0; i < buttons.length; i++) {
            buttons[i].addEventListener('click', function(ebtn) {
                scanInput.value = ebtn.currentTarget.value;
                btnScan.click();
            });
        }

    })
    .catch((error) => {
        console.error('Error:', error);
    });

});

function price_bg(perc) {
    if ((perc / 100) < 0.75) { return "bg-a"; } 
    else if ((perc / 100) < 1.25) { return "bg-c"; } 
    else if ((perc / 100) < 1.5) { return "bg-e"; } 
    else { return "bg-g"; }
}

function year_bg(oldness) {
    if (oldness < 10) { return "bg-a"; } 
    else if (oldness >= 10 && oldness < 20) { return "bg-c"; } 
    else if (oldness >= 20 && oldness < 40) { return "bg-e"; } 
    else { return "bg-g"; }
}

function energetics_BG(energetics) {
    if (energetics == "A" || energetics == "B") { return "bg-a" }
    else if (energetics == "C" || energetics == "D") { return "bg-c"; }
    else if (energetics == "E") { return "bg-e"; }
    else { return "bg-g" }
}

function real_sqm_price_bg(sqmPrice, realSqmPrice) {
    if (realSqmPrice < sqmPrice) {
        return "bg-a";
    } else if (sqmPrice <= realSqmPrice && realSqmPrice < sqmPrice * 1.1 ) {
        return "bg-c";
    } else if (((sqmPrice * 1.1) <= realSqmPrice) && realSqmPrice < sqmPrice * 1.25 ) {
        return "bg-e"; 
    } else { return "bg-g"; }
}

function percent(perc) {
    return perc > 100 ? perc - 100 : -(perc -100);
}