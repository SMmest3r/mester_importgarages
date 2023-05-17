window.addEventListener('message', function (event) {
    var item = event.data;
    if (item.type === 'open') {
        if (item.vehicles.length > 0) {
            document.querySelectorAll('.vehicle').forEach(function (element) {
                element.remove();
            });

            item.vehicles.forEach(function (vehicle) {
                var div = document.createElement('div');
                div.className = 'vehicle';
                div.id = vehicle.plate;
                div.innerHTML = '<div class="vehicle-name">' + vehicle.name + '</div><div class="vehicle-price">' + vehicle.price + '$</div><div class="vehicle-plate">' + vehicle.plate + '</div><button class="pay-button">' + item.translations.Pay + '</button>';
                document.getElementById('container').appendChild(div);
                var plate = vehicle.plate;
                var garage = item.garage;
                div.querySelector('.pay-button').addEventListener('click', function () {
                    $.post('https://mester_impoundgarages/pay', JSON.stringify({
                        plate: plate,
                        garage: garage
                    }));
                });
            });
            document.getElementById('container').style.display = 'flex';
    }
} else if (item.type === 'exit') {
    document.getElementById('container').style.display = 'none';
    }
});



document.onkeyup = function (data) {
    if (data.which == 27) {
        $.post('https://mester_impoundgarages/exit', JSON.stringify({}));
        return
    }
}