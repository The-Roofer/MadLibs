class Madlibs
    attr_accessor :type_of_thing, :user_input, :story_board

    def initialize
        if !File.exist?('stories') || File.read('stories').empty?
            File.write('stories', "The %animal% is %color%\n"+
            "%persons name% was wearing a %color% hat with a %animal% on it \n"+
            "%adjective% %food% is %dead president%'s favorite food\n")
        end
      @storynumber = 0
      @type_of_thing = [] 
      @user_input = []
      @story_board = []
      fill_story_board
    end

    def reset
        #@story_board.clear
        #@type_of_thing.clear   # I was able the eliminate this but left it for learning purpose
        #@user_input.clear
    end
    
    def fill_story_board
        #reset
        content = File.readlines('stories')
            content.each do |line|
                @story_board.push(line)
            end
        display_story_board
    end

    def display_story_board
        system("cls")
            story_board.each_with_index do |story,index|
                puts "Story #{index}: #{story}"
            end

        puts"\nWhich madlibs do you want to do? [Add Story][Remove Story][Exit]"
        @storynumber =  gets.chomp.downcase

            case @storynumber
                when "x","e"
                    exit(0)
                when "a"
                    add_story
                when "r"
                    remove_story
            end 
   
            if @storynumber!="0" && @storynumber.to_i == 0 || @storynumber.to_i >= story_board.size    #exception handling
                    puts "\e[31mEnter a valid choice!!\e[0m"
                    sleep(1.5)
                    display_story_board   # Recursive call to re-start the prompt
            end
            
        @storynumber = @storynumber.to_i    #converts the response to an int to make the arrays happy
        get_user_input
    end
    
    def get_user_input
        system("cls")
        fill_type_of_thing
            type_of_thing.each do |i|
                puts "Name a #{i}"
                @user_input << gets.chomp
            end
        populate_story
    end

    def fill_type_of_thing
        pattern = /%([^%]+)%/ #regex pattern to get everything between %'s
        pattern = /%([\w\s\d]+)%/  # 2 different ones to play with
        
        content = File.readlines('stories')

        matches = content[@storynumber].scan(pattern)   #returns type MatchData

            matches.uniq.each do |match|        # .uniq removes duplicates
                @type_of_thing << match.pop     #pops the item off match array and pushes it into type_of_thing
            end
    end

    # def populate_story
    #         type_of_thing.each_with_index do |thing,index|
    #             @story_board[@storynumber].gsub!("%#{thing}%","#{@user_input[index]}")     #another way to write this
    #         end
    # end

    # def populate_story
    #     type_of_thing.each do |thing|
    #         @story_board[@storynumber].gsub!("%#{thing}%","#{@user_input[type_of_thing.index(thing)]}")    # at this point I realized I could probaly eliminate the reset function
    #     end
    #     read_story
    # end

    # def populate_story
    #     type_of_thing.each do |thing|
    #         @story_board[@storynumber].gsub!("%#{thing}%","#{user_input.shift}") # This eliminates the need to reset user_input by shifting the items out of the array
    #     end
    #     read_story
    # end


    def populate_story
        type_of_thing.size.times do   #wierdly, type_of_thing.each do did not work as intended. It would always leave the last element in the array?
           # type_of_thing.each do
                @story_board[@storynumber].gsub!("%#{type_of_thing.shift}%","#{user_input.shift}") # This eliminates the need to reset user_input by shifting the items out of the array
            #end
        end
    
        read_story
    end
    def read_story
        puts @story_board[@storynumber]
        puts"\n[ENTER] to continue"
        gets
        @story_board.clear
        fill_story_board
    end

    def add_story
        puts "Enter a new Madlib:"
        File.write('stories',gets, mode: 'a')
        @story_board.clear                               #theres probably a way to avoid this clear statement?
        fill_story_board
    end

    def remove_story
        content = File.readlines('stories')              #dumps lines into an 
        puts "Which story do you want to remove?"        #array called content
        content.delete_at(gets.chomp.to_i)         # DELETES chosen line
            File.open('stories', 'w') do |file|    # truncates file and writes new
                content.each do |line|             # array to file line by line
                    file.puts(line)
                end
            end
        @story_board.clear
        fill_story_board
    end
end

class Program
        madlib = Madlibs.new   #makes a Madlibs object that is recursive so no need to loop. Not sure if best practice?
end