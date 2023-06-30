$(document).ready(function() {
    $.ajax({
        type: "GET",
        url: "/.auth/me",
        success: function(data) {
            if (data[0] && data[0].user_id) {
                window.clarity("identity", data[0].user_id);
            }
        }
    });
});
