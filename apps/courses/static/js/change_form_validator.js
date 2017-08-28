var removeCourses = [];
var addCourses = [];

function toObject(arr) {
    var rv = {};
    for (var i = 0; i < arr.length; ++i)
        rv[i] = arr[i];
    return rv;
}

$(document).ready(function() {
    $('#change_form').bootstrapValidator({
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
                    },
                  integer: {
                    message: 'Please enter valid number'
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

            var new_courses = {};
            var new_user_courses = user_courses.slice()

            for (var i = 0; i < user_courses.length; i++) {
                new_courses[new_user_courses[i][0]] = new_user_courses[i][3]
            }

            // Use Ajax to submit form data
            $.ajax({
                type: "POST",
                url: $(this).data('url'),
                data: $form.serialize(),
                cache: false,
                headers: {
                  'X-CSRFToken': csrf_token
                }
            });
            $.ajax({
                type: "POST",
                url: $(this).data('url'),
                data: new_courses,
                success: function() {
                    $('#success_message').slideDown({ opacity: "show" }, "slow")
                    $('#change_form').data('bootstrapValidator').resetForm();
                },
                headers: {
                  'X-CSRFToken': csrf_token
                }
            });
        });
});

$('#addCourceForStudent').on('click', function() {
    var selectedCourseId = $('#coursesSelector').val();
    var selectedCourseText = $('#coursesSelector :selected').text();
    var element =   "<tr><td>"+selectedCourseText+"</td>" +
                    "<td class='text-right'><button class='removeCourseTableBtn' id='removeCourse_"+selectedCourseId+"' type='button'>" +
                            "<i class='fa fa-times-circle-o' aria-hidden='true'></i>" +
                        "</button></td></tr>";
    $("#coursesSelector option[value='"+selectedCourseId+"']").each(function() {
        $(this).remove();
    });
    if (selectedCourseId) {
        $('#coursesTable tbody').append(element);
    }

    for(var i=0;i<user_courses.length;i++) {
        if(user_courses[i][0]===parseInt(selectedCourseId)){
            user_courses[i][3] = true;
        }
    }
});

$(document).on('click', '.removeCourseTableBtn', function() {
    var courseName = $(this).parent().parent().children().text()
    var courseId = $(this).attr('id').split('_')[1];
    $(this).parent().parent().hide();

    var element = '<option value="'+courseId+'">'+courseName+'</option>';
    $('#coursesSelector').append(element);

    for(var i=0;i<user_courses.length;i++) {
        if(user_courses[i][0]===parseInt(courseId)){
            user_courses[i][3] = false;
        }
    }
});