------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                              P R J . P R O C                             --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 2001-2009, Free Software Foundation, Inc.         --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License  distributed with GNAT; see file COPYING3.  If not, go to --
-- http://www.gnu.org/licenses for a complete copy of the license.          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

--  This package is used to convert a project file tree (see prj-tree.ads) to
--  project file data structures (see prj.ads), taking into account the
--  environment (external references).

with Prj.Tree;  use Prj.Tree;

package Prj.Proc is

   procedure Process_Project_Tree_Phase_1
     (In_Tree                : Project_Tree_Ref;
      Project                : out Project_Id;
      Success                : out Boolean;
      From_Project_Node      : Project_Node_Id;
      From_Project_Node_Tree : Project_Node_Tree_Ref;
      Report_Error           : Put_Line_Access;
      Reset_Tree             : Boolean := True);
   --  Process a project tree (ie the direct resulting of parsing a .gpr file)
   --  based on the current scenario variables.
   --
   --  The result of this phase_1 is a partial project tree (Project) where
   --  only a few fields have been initialized (in particular the list of
   --  languages). These are the fields that are necessary to run gprconfig if
   --  needed to automatically generate a configuration file. This first phase
   --  of the processing does not require a configuration file.
   --
   --  If Report_Error is null, use the error reporting mechanism. Otherwise,
   --  report errors using Report_Error.
   --
   --  When_No_Sources indicates what should be done when no sources are found
   --  in a project for a specified or implied language.
   --
   --  When Reset_Tree is True, all the project data are removed from the
   --  project table before processing.

   procedure Process_Project_Tree_Phase_2
     (In_Tree                   : Project_Tree_Ref;
      Project                   : Project_Id;
      Success                   : out Boolean;
      From_Project_Node         : Project_Node_Id;
      From_Project_Node_Tree    : Project_Node_Tree_Ref;
      Report_Error              : Put_Line_Access;
      When_No_Sources           : Error_Warning := Error;
      Current_Dir               : String;
      Is_Config_File            : Boolean;
      Compiler_Driver_Mandatory : Boolean;
      Allow_Duplicate_Basenames : Boolean);
   --  Perform the second phase of the processing, filling the rest of the
   --  project with the information extracted from the project tree. This phase
   --  requires that the configuration file has already been parsed (in fact
   --  we currently assume that the contents of the configuration file has
   --  been included in Project through Confgpr.Apply_Config_File). The
   --  parameters are the same as for phase_1, with the addition of:
   --
   --  Current_Dir is for optimization purposes, avoiding extra system calls.
   --
   --  Is_Config_File should be true if Project is a config file (.cgpr)
   --
   --  If Allow_Duplicate_Basenames, then files with the same base names are
   --  authorized within a project for source-based languages (never for unit
   --  based languages)

   procedure Process
     (In_Tree                : Project_Tree_Ref;
      Project                : out Project_Id;
      Success                : out Boolean;
      From_Project_Node      : Project_Node_Id;
      From_Project_Node_Tree : Project_Node_Tree_Ref;
      Report_Error           : Put_Line_Access;
      When_No_Sources        : Error_Warning := Error;
      Reset_Tree             : Boolean := True;
      Current_Dir            : String := "";
      Is_Config_File         : Boolean);
   --  Performs the two phases of the processing

end Prj.Proc;
