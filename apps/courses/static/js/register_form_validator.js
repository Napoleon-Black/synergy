$(document).ready(function() {
    $('#register_form').bootstrapValidator({
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            name: {
                validators: {
                        stringLength: {
                        min: 2,
                    },
                        notEmpty: {
                        message: 'Please enter your Name'
                    }
                }
            },
            email: {
                validators: {
                    notEmpty: {
                        message: 'Please enter your Email Address'
                    },
                    emailAddress: {
                        message: 'Please enter a valid Email Address'
                    }
                }
            },
            phone_no: {
                validators: {
                  stringLength: {
                        min: 10, 
                        max: 13,
                    }
                }
            },
            mobile_no: {
                validators: {
                  stringLength: {
                        min: 10, 
                        max: 13,
                    }
                }
            },
            status: {
                validators: {
                    notEmpty: {
                        message: 'Please select User status'
                    }
                }
            },
                }
        }).on('success.form.bv', function(e) {

            // Prevent form submission
            e.preventDefault();

            // Get the form instance
            var $form = $(e.target);

            // Get the BootstrapValidator instance
            var bv = $form.data('bootstrapValidator');

            // Use Ajax to submit form data
            $.ajax({
                type: "POST",
                url: $(this).data('url'),
                data: $form.serialize(),
                cache: false,
                success: function() {
                    $('#success_message').slideDown({ opacity: "show" }, "slow")
                    $('#register_form').data('bootstrapValidator').resetForm();
                    setTimeout(function(){
                        window.location.href = '/';
                    }, 3000)
                },
                headers: {
                  'X-CSRFToken': csrf_token
                }
              });
        });
});