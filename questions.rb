require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

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
end

class Question
    attr_accessor :id, :title, :body, :user_id
    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM questions
            WHERE id = ?
        SQL
        return nil if question.length == 0 #if it doesn't match, it's of length 0
        Question.new(question.first) #just gets the hash from the array
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end
end

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

class Reply
    attr_accessor :id, :question_id, :parent_id, :user_id, :body
    def self.find_by_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM replies
            WHERE id = ?
        SQL
        return nil if reply.length == 0 #if it doesn't match, it's of length 0
        Reply.new(reply.first) #just gets the hash from the array
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_id = options['parent_id']
        @user_id = options['user_id']
        @body = options['body']
    end
end

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
