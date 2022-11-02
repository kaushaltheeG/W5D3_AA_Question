class QuestionLike
    attr_accessor :id, :likes, :user_id, :question_id
    def self.find_by_id(id)
        like = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM question_likes
            WHERE id = ?
        SQL
        return nil if like.length == 0 #if it doesn't match, it's of length 0
        QuestionLike.new(like.first) #just gets the hash from the array
    end

    def initialize(options)
        @id = options['id']
        @likes = options['likes']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

end