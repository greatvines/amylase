module JobSpecsHelper

  # Public: Used to generate dummy job_template objects for submitting a job spec form.
  # I was running into a problem with fields_for where after I submitted the form,
  # any parts of the form that weren't for the specified template would return an
  # error that the field did not exist (since job_template is polymorphic).  This
  # will submit the form using dummy objects for all of the job_templates that are not
  # selected.
  #
  # job_spec          - The JobSpec object that the form is being used to create/edit.
  # job_template_type - A string holding the name of the job template class.
  #
  # Returns either the specific job_template or a dummy object that is of the right class.
  def form_job_template_object(job_spec, job_template_type)
    if job_spec.job_template_type == job_template_type
      job_spec.job_template
    else
      job_template_type.constantize.new
    end
  end
end
