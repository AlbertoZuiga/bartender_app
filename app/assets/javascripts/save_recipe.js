function saveRecipe(id) {
    if (document.querySelector('#save-recipe-'+id).checked){
        check = true
    } else{
        check = false
    };
    console.log(check)

    let recipe = {recipe_id: id, checked: check};

    const authenticityToken = document.querySelector('meta[name="csrf-token"]').content;

    const xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
            const response = JSON.parse(xhr.responseText);
        } else {
            console.error('Error:', xhr.status);
        }
        }
    };

    xhr.open('POST', '/recipes/'+id+'/save', true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('X-CSRF-Token', authenticityToken);
    xhr.send(JSON.stringify({ recipe }));
}