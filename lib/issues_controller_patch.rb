module IssuesControllerPatch
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      alias_method_chain :create, :recaptcha_verification
#      alias_method_chain :update, :recaptcha_verification
    end
  end
  
  module InstanceMethods
    def create_with_recaptcha_verification
      unless User.current.allowed_to?(:add_issues, @issue.project, :global => true)
        raise ::Unauthorized
      end
      call_hook(:controller_issues_new_before_save, { :params => params, :issue => @issue })
      @issue.save_attachments(params[:attachments] || (params[:issue] && params[:issue][:uploads]))
      if (User.current.member_of?(@project.parent) || verify_recaptcha( :secret_key => Setting.plugin_redmine_recaptcha_v2['secret_key'], :model => @user, :message => "reCAPTCHA verification failed. Please try again." )) && @issue.save
        call_hook(:controller_issues_new_after_save, { :params => params, :issue => @issue})
        respond_to do |format|
          format.html {
            render_attachment_warning_if_needed(@issue)
            flash[:notice] = l(:notice_issue_successful_create, :id => view_context.link_to("##{@issue.id}", issue_path(@issue), :title => @issue.subject))
            redirect_after_create
          }
          format.api  { render :action => 'show', :status => :created, :location => issue_url(@issue) }
        end
        return
      else
        respond_to do |format|
          format.html {
            if @issue.project.nil?
              render_error :status => 422
            else
              render :action => 'new'
            end
          }
          format.api  { render_validation_errors(@issue) }
        end
      end
        #the old method is accessible here:
        #create_without_recaptcha_verification
    end

#    Disabling this for now.  When recaptcha would fail, the error message would get displayed but the issue still got updated.
#    We primarily care about new issues getting created with recaptcha (which does work)
#
#    def update_with_recaptcha_verification
#      return unless update_issue_from_params
#      @issue.save_attachments(params[:attachments] || (params[:issue] && params[:issue][:uploads]))
#      saved = false
#      begin
#        saved = save_issue_with_child_records
#      rescue ActiveRecord::StaleObjectError
#        @conflict = true
#        if params[:last_journal_id]
#          @conflict_journals = @issue.journals_after(params[:last_journal_id]).to_a
#          @conflict_journals.reject!(&:private_notes?) unless User.current.allowed_to?(:view_private_notes, @issue.project)
#        end
#      end
#  
#      if (User.current.member_of?(@project.parent) || verify_recaptcha( :secret_key => Setting.plugin_redmine_recaptcha_v2['secret_key'], :model => @user, :message => "reCAPTCHA verification failed. Please try again." )) && saved
#        render_attachment_warning_if_needed(@issue)
#        flash[:notice] = l(:notice_successful_update) unless @issue.current_journal.new_record?
#  
#        respond_to do |format|
#          format.html { redirect_back_or_default issue_path(@issue, previous_and_next_issue_ids_params) }
#          format.api  { render_api_ok }
#        end
#      else
#        respond_to do |format|
#          format.html { render :action => 'edit' }
#          format.api  { render_validation_errors(@issue) }
#        end
#      end
#        #the old method is accessible here:
#        #update_without_recaptcha_verification
#    end
  end
end

