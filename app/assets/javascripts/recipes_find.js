function findRecipes(id) {
    if (document.querySelector('#ingredient-checkbox-'+id).checked){
        check = true
    } else{
        check = false
    };
    
    let ingredient = {ingredient_id: id, checked: check};
    
    const authenticityToken = document.querySelector('meta[name="csrf-token"]').content;
    
    const xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
            const response = JSON.parse(xhr.responseText);
            displayList(response.recipes);
        } else {
            console.error('Error:', xhr.status);
        }
        }
    };
    
    xhr.open('POST', '/recipes/find', true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('X-CSRF-Token', authenticityToken);
    xhr.send(JSON.stringify({ ingredient }));
}
    
function displayList(recipes) {
  let contenedor = document.getElementById('make_recipes');
  contenedor.innerHTML = '';

  let div = document.createElement('div');
  div.classList.add('row');

  for (let i = 0; i < recipes.length; i++) {
    let recipe = recipes[i];
    let col = document.createElement('div');
    col.classList.add('col-md-4', 'mb-4', 'text-center');

    let link = document.createElement('a');
    link.classList.add('card');

    let cardBody = document.createElement('div');
    cardBody.classList.add('card-body');

    link.href = recipe.link;
    cardBody.textContent = recipe.name;

    link.appendChild(cardBody);
    col.appendChild(link);
    div.appendChild(col);
  }

  contenedor.appendChild(div);
}