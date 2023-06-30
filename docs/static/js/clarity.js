$(document).ready(function() {
    $.ajax({
        type: "GET",
        url: "/.auth/me",
        success: function(data) {
            if (data[0] && data[0].user_id) {
                // Set identifier as hashed user id
                window.clarity("identify", data[0].user_id);

                // Set user attributes for signed in (preview) users
                window.clarity("set", "user_id", data[0].user_id);
            }
        }
    });
});
