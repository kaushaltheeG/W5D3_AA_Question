require_relative "../questions.rb"
require_relative "user.rb"
require_relative "question.rb"

class QuestionFollow
    attr_accessor :id, :user_id, :question_id

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
        data.map { |datum| QuestionFollow.new(datum) }
    end

    def self.find_by_id(id)
        follow = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM question_follows
            WHERE id = ?
        SQL
        return nil if follow.length == 0 #if it doesn't match, it's of length 0
        QuestionFollow.new(follow.first) #just gets the hash from the array
    end

    def self.followers_for_question_id(question_id)
        user = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT *
            FROM users
            JOIN question_follows
                ON users.id = question_follows.user_id
            JOIN questions
                ON question_follows.question_id = questions.id
            WHERE question_id = ?
        SQL
        return nil if user.length == 0
        user.map {|datum| User.new(datum)}
    end

    def self.followed_questions_for_user_id(user_id)
        question = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT *
            FROM questions
            JOIN question_follows
                ON question_follows.question_id = questions.id
            JOIN users
                ON users.id = question_follows.user_id
            WHERE questions.user_id = ?
        SQL
        return nil if question.length == 0
        question.map {|datum| Question.new(datum)}

    end

    def self.most_followed_questions(n)
        most_followed = QuestionsDatabase.instance.execute(<<-SQL, n)
            SELECT questions.question
            FROM users
            JOIN question_follows
                ON users.id = question_follows.user_id
            JOIN questions
                ON question_follows.question_id = questions.id
            ORDER BY 

        SQL
        return nil if user.length == 0
        user.map {|datum| User.new(datum)}
    end 

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end
end

if $PROGRAM_NAME == __FILE__
    p QuestionFollow.all
    puts
    p QuestionFollow.followers_for_question_id(2)
    puts
    p QuestionFollow.followed_questions_for_user_id(2)
end
