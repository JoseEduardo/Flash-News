package tibia.game
{
   import tibia.appearances.widgetClasses.SkinnedAppearanceRenderer;
   import flash.events.Event;
   import mx.containers.HBox;
   import mx.controls.Text;
   import mx.controls.TextArea;
   import flash.events.KeyboardEvent;
   import tibia.input.PreventWhitespaceInput;
   import flash.events.TextEvent;
   import shared.utility.StringHelper;
   import tibia.appearances.AppearanceTypeRef;
   import tibia.network.Communication;
   import tibia.appearances.AppearanceStorage;
   import tibia.appearances.AppearanceType;
   
   public class EditTextWidget extends PopUpBase
   {
      
      private static const BUNDLE:String = "EditTextWidget";
       
      
      private var m_UncommittedAuthor:Boolean = false;
      
      protected var m_UIObject:SkinnedAppearanceRenderer = null;
      
      private var m_InvalidReadOnly:Boolean = false;
      
      private var m_UncommittedMaxChars:Boolean = false;
      
      protected var m_MaxChars:int = 2.147483647E9;
      
      protected var m_ReadOnly:Boolean = false;
      
      protected var m_ID:uint = 0;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_InvalidHeading:Boolean = false;
      
      private var m_UncommittedObjectRef:Boolean = false;
      
      protected var m_Author:String = null;
      
      private var m_UncommittedText:Boolean = false;
      
      private var m_UncommittedDate:Boolean = false;
      
      protected var m_Date:String = null;
      
      protected var m_ObjectRef:AppearanceTypeRef = null;
      
      private var m_UncommittedID:Boolean = false;
      
      protected var m_Text:String = null;
      
      protected var m_UIText:TextArea = null;
      
      protected var m_UIHeading:Text = null;
      
      public function EditTextWidget()
      {
         super();
         title = resourceManager.getString(BUNDLE,"TITLE");
         keyboardFlags = PopUpBase.KEY_ESCAPE;
         width = 300;
         height = 300;
         this.invalidateReadOnly();
         this.invalidateHeading();
      }
      
      public function get author() : String
      {
         return this.m_Author;
      }
      
      public function set author(param1:String) : void
      {
         if(this.m_Author != param1)
         {
            this.m_Author = param1;
            this.m_UncommittedAuthor = true;
            this.invalidateHeading();
            invalidateProperties();
         }
      }
      
      private function onTextChange(param1:Event) : void
      {
         if(param1 != null)
         {
            this.m_Text = this.m_UIText.text;
         }
      }
      
      public function get ID() : uint
      {
         return this.m_ID;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:HBox = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new HBox();
            _loc1_.percentHeight = NaN;
            _loc1_.percentWidth = 100;
            _loc1_.setStyle("horizontalAlign","left");
            _loc1_.setStyle("verticalAlign","middle");
            _loc1_.setStyle("paddingBottom",0);
            _loc1_.setStyle("paddingLeft",0);
            _loc1_.setStyle("paddingRight",0);
            _loc1_.setStyle("paddingWidth",0);
            this.m_UIObject = new SkinnedAppearanceRenderer();
            _loc1_.addChild(this.m_UIObject);
            this.m_UIHeading = new Text();
            _loc1_.addChild(this.m_UIHeading);
            addChild(_loc1_);
            this.m_UIText = new TextArea();
            this.m_UIText.maxChars = this.m_MaxChars;
            this.m_UIText.percentHeight = 100;
            this.m_UIText.percentWidth = 100;
            this.m_UIText.text = this.m_Text;
            this.m_UIText.addEventListener(Event.CHANGE,this.onTextChange);
            this.m_UIText.addEventListener(KeyboardEvent.KEY_DOWN,PreventWhitespaceInput);
            this.m_UIText.addEventListener(TextEvent.TEXT_INPUT,PreventWhitespaceInput);
            addChild(this.m_UIText);
            this.m_UIConstructed = true;
         }
      }
      
      public function get date() : String
      {
         return this.m_Date;
      }
      
      public function set maxChars(param1:int) : void
      {
         if(this.m_MaxChars != param1)
         {
            if(param1 < this.m_MaxChars && this.m_Text != null)
            {
               this.m_Text = StringHelper.s_Trim(this.m_Text);
               this.m_Text = this.m_Text.substr(0,param1);
               this.m_UncommittedText = true;
               invalidateProperties();
            }
            this.m_MaxChars = param1;
            this.m_UncommittedMaxChars = true;
            invalidateProperties();
         }
      }
      
      public function get text() : String
      {
         return this.m_Text;
      }
      
      public function set ID(param1:uint) : void
      {
         if(this.m_ID != param1)
         {
            this.m_ID = param1;
            this.m_UncommittedID = true;
            invalidateProperties();
         }
      }
      
      public function get object() : AppearanceTypeRef
      {
         return this.m_ObjectRef;
      }
      
      override public function hide(param1:Boolean = false) : void
      {
         var _loc2_:Communication = null;
         if(param1)
         {
            _loc2_ = null;
            if(!this.m_ReadOnly && (_loc2_ = Tibia.s_GetCommunication()) != null && _loc2_.isGameRunning)
            {
               _loc2_.sendCEDITTEXT(this.m_ID,StringHelper.s_CleanNewline(this.m_UIText.text));
            }
         }
         super.hide(param1);
      }
      
      protected function invalidateHeading() : void
      {
         this.m_InvalidHeading = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:AppearanceStorage = null;
         var _loc2_:AppearanceType = null;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         if(this.m_UncommittedAuthor)
         {
            this.m_UncommittedAuthor = false;
         }
         if(this.m_UncommittedDate)
         {
            this.m_UncommittedDate = false;
         }
         if(this.m_UncommittedID)
         {
            this.m_UncommittedID = false;
         }
         if(this.m_UncommittedMaxChars)
         {
            this.m_UIText.maxChars = this.m_MaxChars;
            this.m_UncommittedMaxChars = false;
         }
         if(this.m_UncommittedObjectRef)
         {
            this.m_UIObject.appearance = this.m_ObjectRef;
            this.m_UncommittedObjectRef = false;
         }
         if(this.m_UncommittedText)
         {
            this.m_UIText.text = this.m_Text;
            this.m_UncommittedText = false;
         }
         if(this.m_InvalidReadOnly)
         {
            _loc4_ = this.m_Text != null && this.m_Text.length > 0;
            if(this.m_ObjectRef != null && (_loc1_ = Tibia.s_GetAppearanceStorage()) != null && (_loc2_ = _loc1_.getObjectType(this.m_ObjectRef.ID)) != null)
            {
               this.m_ReadOnly = !(_loc2_.isWriteable || _loc2_.isWriteableOnce && !_loc4_);
            }
            else
            {
               this.m_ReadOnly = true;
            }
            if(this.m_ReadOnly)
            {
               buttonFlags = PopUpBase.BUTTON_CLOSE;
            }
            else
            {
               buttonFlags = PopUpBase.BUTTON_OKAY | PopUpBase.BUTTON_CANCEL;
            }
            this.m_UIText.editable = !this.m_ReadOnly;
            this.invalidateHeading();
            this.m_InvalidReadOnly = false;
         }
         if(this.m_InvalidHeading)
         {
            _loc5_ = this.m_Author != null && this.m_Author.length > 0;
            _loc6_ = this.m_Date != null && this.m_Date.length > 0;
            _loc4_ = this.m_Text != null && this.m_Text.length > 0;
            if(this.m_ReadOnly)
            {
               if(_loc4_ && _loc5_ && _loc6_)
               {
                  _loc3_ = "HEADING_RO_TEXT_AUTHOR_DATE";
               }
               else if(_loc4_ && _loc5_ && !_loc6_)
               {
                  _loc3_ = "HEADING_RO_TEXT_AUTHOR";
               }
               else if(_loc4_)
               {
                  _loc3_ = "HEADING_RO_TEXT";
               }
               else
               {
                  _loc3_ = "HEADING_RO";
               }
            }
            else if(_loc4_ && _loc5_ && _loc6_)
            {
               _loc3_ = "HEADING_RW_TEXT_AUTHOR_DATE";
            }
            else if(_loc4_ && _loc5_ && !_loc6_)
            {
               _loc3_ = "HEADING_RW_TEXT_AUTHOR";
            }
            else if(_loc4_)
            {
               _loc3_ = "HEADING_RW_TEXT";
            }
            else
            {
               _loc3_ = "HEADING_RW";
            }
            this.m_UIHeading.text = resourceManager.getString(BUNDLE,_loc3_,[this.m_Author,this.m_Date]);
            this.m_InvalidHeading = false;
         }
         super.commitProperties();
      }
      
      protected function invalidateReadOnly() : void
      {
         this.m_InvalidReadOnly = true;
         invalidateProperties();
      }
      
      public function get maxChars() : int
      {
         return this.m_MaxChars;
      }
      
      public function set date(param1:String) : void
      {
         if(this.m_Date != param1)
         {
            this.m_Date = param1;
            this.m_UncommittedDate = true;
            this.invalidateHeading();
            invalidateProperties();
         }
      }
      
      public function set text(param1:String) : void
      {
         if(param1 != null)
         {
            param1 = StringHelper.s_Trim(param1);
            param1 = param1.substr(0,this.m_MaxChars);
         }
         if(this.m_Text != param1)
         {
            this.m_Text = param1;
            this.m_UncommittedText = true;
            this.invalidateHeading();
            invalidateProperties();
            this.invalidateReadOnly();
         }
      }
      
      public function set object(param1:AppearanceTypeRef) : void
      {
         if(this.m_ObjectRef != param1)
         {
            this.m_ObjectRef = param1;
            this.m_UncommittedObjectRef = true;
            this.invalidateHeading();
            invalidateProperties();
            this.invalidateReadOnly();
         }
      }
   }
}
