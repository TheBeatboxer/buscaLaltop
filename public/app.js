const form = document.getElementById('laptopForm');
const laptopList = document.getElementById('laptopList');

// Función para cargar las laptops
async function fetchLaptops() {
    const response = await fetch('/api/laptops');
    const laptops = await response.json();
    laptopList.innerHTML = '';
    laptops.forEach(laptop => {
        const li = document.createElement('li');
        li.innerHTML = `${laptop.brand} - ${laptop.model} - ${laptop.status} - ${laptop.price}`;
        laptopList.appendChild(li);
    });
}

// Manejar el submit del formulario
form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const brand = document.getElementById('brand').value;
    const model = document.getElementById('model').value;
    const price = document.getElementById('price').value;
    const status = document.getElementById('status').value;

    await fetch('/api/laptops', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ brand, model, price, status })
    });
    form.reset();
    fetchLaptops();
});

// Cargar las laptops al iniciar
fetchLaptops();
