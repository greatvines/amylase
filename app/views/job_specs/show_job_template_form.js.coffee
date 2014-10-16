selected = () -> $('#job_template_type_selector').val()

$('.job_template_form').hide()
$('#' + selected()).show()
