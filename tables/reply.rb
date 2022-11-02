require_relative "../questions.rb"
require_relative "user.rb"
require_relative "question.rb"


class Reply
    attr_accessor :id, :question_id, :parent_id, :user_id, :body

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
        data.map { |datum| Reply.new(datum) }
    end

    def self.find_by_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM replies
            WHERE id = ?
        SQL
        return nil if reply.length == 0 #if it doesn't match, it's of length 0
        Reply.new(reply.first) #just gets the hash from the array
    end

    def self.find_by_user_id(user_id)
        user = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT *
            FROM replies
            WHERE user_id = ?
        SQL
        return nil if user.length == 0 #if it doesn't match, it's of length 0
        Reply.new(user.first) #just gets the hash from the array
    end 

    def self.find_by_question_id(question_id)
        question = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT *
            FROM replies
            WHERE question_id = ?

        SQL
        return nil if question.length == 0 #if it doesn't match, it's of length 0
        Reply.new(question.first) #just gets the hash from the array
    end

    def self.find_child(question_id,parent_id)
        child = QuestionsDatabase.instance.execute(<<-SQL, question_id, parent_id)
            SELECT *
            FROM replies
            WHERE question_id = ?
                AND parent_id = ?
        SQL
        return nil if child.length == 0 #if it doesn't match, it's of length 0
        Reply.new(child.first) #just gets the hash from the array
    end 


    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_id = options['parent_id']
        @user_id = options['user_id']
        @body = options['body']
    end

    def author 
        User.find_by_id(self.user_id) #retriving id, firstname, lastname from the Users table
    end 

    def question 
        Question.find_by_id(self.question_id) 
    end 

    def parent_reply 
        Reply.find_by_question_id(self.question_id).body
    end 

    def child_replies
        Reply.find_child(self.question_id, self.parent_id).body
    end 
end

r = Reply.all 
p r 
#p r[0].parent_reply
#p r[0].child_replies
#p r[1].parent_reply
#p r[1].child_replies