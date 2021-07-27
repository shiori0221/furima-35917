function price (){
  const itemPrice = document.getElementById("item-price");
  itemPrice.addEventListener("keyup", () => {
    const addTax = itemPrice.value * 0.1;
    const addTaxPrice = document.getElementById("add-tax-price")
    addTaxPrice.innerHTML = `${addTax}`;
    const profit = itemPrice.value - addTax
    const profitPrice = document.getElementById("profit")
    profitPrice.innerHTML = `${profit}`;
  })
}

window.addEventListener('load', price)