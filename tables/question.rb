class Question
    attr_accessor :id, :title, :body, :user_id

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
        data.map { |datum| Question.new(datum) }
    end

    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM questions
            WHERE id = ?
        SQL
        return nil if question.length == 0 #if it doesn't match, it's of length 0
        Question.new(question.first) #just gets the hash from the array
    end

    def self.find_by_author(user_id)
        author = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT *
            FROM questions
            WHERE user_id = ?
        SQL
        return nil if author.length == 0 #if it doesn't match, it's of length 0
        Question.new(author.first) #just gets the hash from the array
    end 

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end

    def author
        self.user_id
    end 

    def replies 
        Reply.find_by_question_id(self.id)
    end 

end