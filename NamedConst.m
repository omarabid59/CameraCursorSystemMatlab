classdef NamedConst
   properties (Constant)
       
         
         %% List of the commands to implement
         move_string = {'no movement','move_left','move_right','move_up','move_down'};
         move_left = 1;
         move_right = 2;
         move_up = 3;
         move_down = 4;
         move_top_right = 5;
         no_movement = 0;
         
         
         %% Poses
         fist_pose = 2;
         bunny_pose = 3;
         thumbs_up_pose = 2;
         open_hand_pose = 1;
         no_pose = 0;
         

         do_nothing = 0;
         %% Actions
         swipe_left = 1;
         swipe_right = 2;
         
         scroll_down = 3;
         scroll_up = 4;
         
         control_mouse = 5;
         volume_up = 6;;
         volume_down = 7;
         arrow_left = 8;
         arrow_right = 9;
         arrow_up = 11;
         arrow_down = 12;
         space_key = 10;
   end
end