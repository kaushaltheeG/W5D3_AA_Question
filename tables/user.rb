require_relative "../questions.rb"
require_relative "question_follow.rb"

class User
    attr_accessor :fname, :lname, :id
    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM users")
        data.map { |datum| User.new(datum) }
    end

    def self.find_by_id(id)
        user = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM users
            WHERE id = ?
        SQL
        return nil if user.length == 0 #if it doesn't match, it's of length 0
        User.new(user.first) #just gets the hash from the array
    end

    def self.find_by_name(fname, lname)
        person = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT *
            FROM users
            WHERE fname = ? AND lname = ?
        SQL
        return nil if person.length == 0 #if it doesn't match, it's of length 0
        User.new(person.first) #just gets the hash from the array
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def create
        QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
            INSERT INTO
                users (fname, lname)
            VALUES
                (?, ?)
            SQL
        self.id = QuestionsDatabase.instance.last_insert_row_id
    end

    def update
        QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname, self.id)
         UPDATE
             users
         SET
             fname = ?, lname = ?
         WHERE
             id = ?
         SQL
    end

    def authored_questions
        Question.find_by_author_id(self.id)
    end

    def authored_replies
        Reply.find_by_user_id(self.id)
    end

    def followed_questions
        QuestionFollow.followed_questions_for_user_id(self.id)
    end
end

if $PROGRAM_NAME == __FILE__
    u = User.all
    p u
    puts 
    p u[1].followed_questions
end
