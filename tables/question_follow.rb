class QuestionFollow
    attr_accessor :id, :user_id, :question_id
    def self.find_by_id(id)
        follow = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM question_follows
            WHERE id = ?
        SQL
        return nil if follow.length == 0 #if it doesn't match, it's of length 0
        QuestionFollow.new(follow.first) #just gets the hash from the array
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end
end