$(document).ready(function() {
    $.ajax({
        type: "GET",
        url: "/.auth/me",
        success: function(data) {
            window.clarity("identity", data[0].user_id);
        }
    });
});
