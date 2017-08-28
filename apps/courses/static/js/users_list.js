function addURLParameters(param, data) {
    var search = location.search.substring(1);
    var params = search?JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g,'":"') + '"}',
                 function(key, value) { return key===""?value:decodeURIComponent(value) }):{}
    params[param] = data;
    var params_str = "";
    for (var key in params) {
        if (params_str != "") {
            params_str += "&";
        }
        params_str += key + "=" + encodeURIComponent(params[key]);
    }
    window.location.href = '?' + params_str;
}

function searchUsers() {
    var usersFilter = $('#searchUserInput').val();
    addURLParameters('search', usersFilter);
}

$('.editUsersTableBtn').on('click', function() {
    var user_id = $(this).attr('id').split('_')[1];
    window.location.href = 'change-user/' + user_id;
});

$('.removeUsersTableBtn').on('click', function() {
    var user_id = $(this).attr('id').split('_')[1];
    $.ajax({
        type: "POST",
        url: $(this).data('url'),
        data: {'remove_user': user_id},
        cache: false,
        success: function() {
            $('#removeUser_'+user_id).parent().parent().hide();
        },
        headers: {
          'X-CSRFToken': csrf_token
        }
    });
})

$('#limitSelector').on('changed.bs.select', function(e, clickedIndex, newValue, oldValue) {
    var selected = $(e.currentTarget).val();
    addURLParameters('limit', selected)
});

// Filter by users name
$('#searchUserBtn').on('click', searchUsers);
$('#searchUserInput').keypress(function(e) {
    if (e.which == 13) {
        searchUsers();
    }
});

$('#searchUserBlock form').submit(false);