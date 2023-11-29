class MultipleChoiceCheckbox < QuizQuestion
  def edit
    super
    # for i in 0..3
    [0, 1, 2, 3].each do |i|
      @html += '<tr><td>'

      @html += '<input type="hidden" name="quiz_question_choices[' + id.to_s + '][MultipleChoiceCheckbox][' + (i + 1).to_s + '][iscorrect]" '
      @html += 'id="quiz_question_choices_' + id.to_s + '_MultipleChoiceCheckbox_' + (i + 1).to_s + '_iscorrect" value="0" />'

      @html += '<input type="checkbox" name="quiz_question_choices[' + id.to_s + '][MultipleChoiceCheckbox][' + (i + 1).to_s + '][iscorrect]" '
      @html += 'id="quiz_question_choices_' + id.to_s + '_MultipleChoiceCheckbox_' + (i + 1).to_s + '_iscorrect" value="1" '
      @html += 'checked="checked" ' if @quiz_question_choices[i].iscorrect
      @html += '/>'

      @html += '<input type="text" name="quiz_question_choices[' + id.to_s + '][MultipleChoiceCheckbox][' + (i + 1).to_s + '][txt]" '
      @html += 'id="quiz_question_choices_' + id.to_s + '_MultipleChoiceCheckbox_' + (i + 1).to_s + '_txt" '
      @html += 'value="' + @quiz_question_choices[i].txt + '" size="40" />'

      @html += '</td></tr>'
    end

    @html.html_safe
    # safe_join(@html)
  end

  def complete
    # quiz_question_choices = QuizQuestionChoice.where(question_id: id)
    # @html = '<label for="' + id.to_s + '">' + txt + '</label><br>'
    # for i in 0..3
    [0, 1, 2, 3].each do |i|
      # txt = quiz_question_choices[i].txt
      @html += '<input name = ' + "\"#{id}[]\" "
      @html += 'id = ' + "\"#{id}" + '_' + "#{i + 1}\" "
      @html += 'value = ' + "\"#{quiz_question_choices[i].txt}\" "
      @html += 'type="checkbox"/>'
      @html += quiz_question_choices[i].txt.to_s
      @html += '</br>'
    end
    @html
  end

  def view_completed_question(user_answer)
    quiz_question_choices = QuizQuestionChoice.where(question_id: id)
    @html = ''
    quiz_question_choices.each do |answer|
      @html += '<b>' + answer.txt + '</b> -- Correct <br>' if answer.iscorrect
    end
    @html += '<br>Your answer is:'
    @html += if user_answer[0].answer == 1
              '<img src="/assets/Check-icon.png"/><br>'
            else
              '<img src="/assets/delete_icon.png"/><br>'
            end
    user_answer.each do |answer|
      @html += '<b>' + answer.comments.to_s + '</b><br>'
    end
    @html += '<br><hr>'
    @html.html_safe
    # safe_join(html)
  end

  def isvalid(choice_info)
    @valid = super(choice_info)

    correct_count = 0
    # choice_info.each do |_idx, value|
    choice_info.each_value do |value|
      if value[:txt] == ''
        @valid = 'Please make sure every question has text for all options'
        break
      end
      correct_count += 1 if value[:iscorrect] == 1.to_s
    end
    # if correct_count == 0
    if correct_count.zero?
      @valid = 'Please select a correct answer for all questions'
    elsif correct_count == 1
      @valid = 'A multiple-choice checkbox question should have more than one correct answer.'
    elsif correct_count == 2
      @valid = 'valid'
    end
    @valid
  end
end
