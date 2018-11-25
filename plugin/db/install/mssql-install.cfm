<cfquery name="Create-p_EventRegistration_Caterers" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE [dbo].[p_EventRegistration_Caterers](
		[TContent_ID] [int] IDENTITY (1, 1) NOT NULL, [Site_ID] [nvarchar] (25) NOT NULL, [FacilityName] [nvarchar](50) NULL, [PhysicalAddress] [nvarchar](max) NULL,
		[PhysicalCity] [nvarchar](50) NULL, [PhysicalState] [nvarchar](50) NULL, [PhysicalZipCode] [nvarchar](10) NULL, [PhysicalZip4] [nvarchar](10) NULL,
		[PrimaryVoiceNumber] [nvarchar](50) NULL, [BusinessWebsite] [nvarchar](max) NULL, [ContactName] [nvarchar](50) NULL, [ContactEmail] [nvarchar](50) NULL,
		[ContactPhoneNumber] [nvarchar](50) NULL, [PaymentTerms] [nvarchar] (max) NULL, [DeliveryInfo] [nvarchar] (max) NULL, [GuaranteeInformation] [nvarchar] (max) NULL,
		[AdditionalNotes] [nvarchar] (max) NULL, [dateCreated] [datetime] NULL, [lastUpdated] [datetime] NULL, [lastUpdateBy] [nvarchar](max) NULL,
		[isAddressVerified] [bit] NOT NULL, [GeoCode_Latitude] [nvarchar](50) NULL, [GeoCode_Longitude] [nvarchar](50) NULL, [GeoCode_Township] [nvarchar](50) NULL,
		[GeoCode_StateLongName] [nvarchar](50) NULL, [GeoCode_CountryShortName] [nvarchar](50) NULL, [GeoCode_Neighborhood] [nvarchar](50) NULL, [Active] [bit] NOT NULL,
			CONSTRAINT [PK_p_EventRegistration_Caterers] PRIMARY KEY CLUSTERED ( [TContent_ID] ASC ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
</cfquery>

<cfquery name="Create-p_EventRegistration_EventExpenses" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE [dbo].[p_EventRegistration_EventExpenses](
	[TContent_ID] [int] IDENTITY (1, 1) NOT NULL, [Site_ID] [nvarchar] (25) NOT NULL, [Event_ID] [int] NOT NULL, [Expense_ID] [int] NOT NULL,
	[Cost_Amount] [money] NOT NULL, [dateCreated] [datetime] NOT NULL, [lastUpdated] [datetime] NOT NULL, [lastUpdateBy] [nvarchar](50) NOT NULL, [Cost_Verified] [bit] NOT NULL,
	CONSTRAINT [PK_p_EventRegistration_EventExpenses] PRIMARY KEY CLUSTERED ( [TContent_ID] ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
</cfquery>

<cfquery name="Create-p_EventRegistration_ExpenseList" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE [dbo].[p_EventRegistration_ExpenseList](
	[TContent_ID] [int] IDENTITY (1, 1) NOT NULL, [Site_ID] [nvarchar] (25) NOT NULL, [Expense_Name] [nvarchar](50) NOT NULL, [Active] [bit] NOT NULL,
	[dataeCreated] [datetime] NOT NULL, [lastUpdatead] [datetime] NOT NULL, [lastUpdateBy] [nvarchar](50) NOT NULL,
	CONSTRAINT [PK_p_EventRegistration_ExpenseList] PRIMARY KEY CLUSTERED ( [TContent_ID] ASC ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
</cfquery>

<cfquery name="Create-p_EventRegistration_Facility" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE [dbo].[p_EventRegistration_Facility](
	[TContent_ID] [int] IDENTITY (1, 1) NOT NULL, [Site_ID] [nvarchar] (25) NOT NULL, [FacilityName] [nvarchar](50) NULL, [PhysicalAddress] [nvarchar](max) NULL, [PhysicalCity] [nvarchar](50) NULL,
	[PhysicalState] [nvarchar](50) NULL, [PhysicalZipCode] [nvarchar](50) NULL, [PhysicalZip4] [nvarchar](10) NULL, [PrimaryVoiceNumber] [nvarchar](50) NULL, [BusinessWebsite] [nvarchar](max) NULL,
	[ContactName] [nvarchar](50) NULL, [ContactPhoneNumber] [nvarchar](50) NULL, [ContactEmail] [nvarchar](50) NULL, [dateCreated] [datetime] NOT NULL, [lastUpdated] [datetime] NULL,
	[lastUpdateBy] [nvarchar](50) NULL, [isAddressVerified] [bit] NOT NULL, [GeoCode_Latitude] [nvarchar](50) NULL, [GeoCode_Longitude] [nvarchar](50) NULL, [GeoCode_Township] [nvarchar](50) NULL,
	[GeoCode_StateLongName] [nvarchar](50) NULL, [GeoCode_CountryShortName] [nvarchar](50) NULL, [GeoCode_Neighborhood] [nvarchar](50) NULL, [USPS_CarrierRoute] [nvarchar](50) NULL,
	[USPS_CheckDigit] [nvarchar](10) NULL, [USPS_DeliveryPoint] [nvarchar](10) NULL, [PhysicalLocationCountry] [nvarchar](50) NULL, [PhysicalCountry] [nvarchar](50) NULL,
	[Active] [bit] NOT NULL, [FacilityType] [char](1) NULL,
	CONSTRAINT [PK_p_EventRegistration_Facility] PRIMARY KEY CLUSTERED ( [TContent_ID] ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
</cfquery>

<cfquery name="Create-p_EventRegistration_FacilityRooms" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE [dbo].[p_EventRegistration_FacilityRooms](
	[TContent_ID] [int] IDENTITY (1, 1) NOT NULL, [Site_ID] [nvarchar] (25) NOT NULL, [Facility_ID] [int] NOT NULL, [RoomName] [nvarchar](50) NOT NULL, [Capacity] [int] NOT NULL, [RoomFees] [money] NULL,
	[Active] [bit] NOT NULL, [dateCreated] [datetime] NOT NULL, [lastUpdated] [datetime] NOT NULL, [lastUpdateBy] [nvarchar](50) NOT NULL ) ON [PRIMARY]
</cfquery>

<cfquery name="Create-p_EventRegistration_Membership" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE [dbo].[p_EventRegistration_Membership](
	[TContent_ID] [int] IDENTITY (1, 1) NOT NULL, [Site_ID] [nvarchar] (25) NOT NULL, [OrganizationName] [varchar](50) NOT NULL, [OrganizationDomainName] [nvarchar](50) NOT NULL,
	[StateDOE_IDNumber] [nvarchar](10) NOT NULL, [StateDOE_State] [nvarchar](50) NOT NULL, [Active] [bit] NOT NULL, [dateCreated] [datetime] NOT NULL, [lastUpdateBy] [nvarchar](35) NOT NULL,
	[lastUpdated] [datetime] NOT NULL, [Mailing_Address] [nvarchar](50) NULL, [Mailing_City] [nvarchar](50) NULL, [Mailing_State] [nvarchar](50) NULL, [Mailing_ZipCode] [nvarchar](50) NULL,
	[Primary_PhoneNumber] [nvarchar](50) NULL, [Primary_FaxNumber] [nvarchar](50) NULL, [Physical_Address] [nvarchar](50) NULL, [Physical_City] [nvarchar](50) NULL,
	[Physical_State] [nvarchar](50) NULL, [Physical_ZipCode] [nvarchar](50) NULL, [AccountsPayable_EmailAddress] [nvarchar](50) NULL, [AccountsPayable_ContactName] [nvarchar](50) NULL,
	[ReceiveInvoicesByEmnail] [bit] NOT NULL, CONSTRAINT [PK_p_EventRegistration_Membership] PRIMARY KEY CLUSTERED
	( [TContent_ID] ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
</cfquery>

<cfquery name="Create-p_EventRegistration_SiteConfig" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE [dbo].[p_EventRegistration_SiteConfig](
	[TContent_ID] [int] IDENTITY (1, 1) NOT NULL, [Site_ID] [nvarchar] (25) NOT NULL, [dateCreated] [datetime] NOT NULL, [lastUpdateBy] [nchar](35) NULL, [lastUpdated] [datetime] NOT NULL,
	[ProcessPayments_Stripe] [bit] NOT NULL, [Stripe_TestMode] [bit] NOT NULL, [Stripe_TestAPIKey] [nvarchar](50) NULL, [Stripe_LiveAPIKey] [nvarchar](50) NULL,
	[Facebook_AppID] [nvarchar](50) NULL, [Facebook_AppSecretKey] [nvarchar](50) NULL, [Facebook_PageID] [nvarchar](50) NULL, [Facebook_AppScope] [nvarchar](50) NULL,
	CONSTRAINT [PK_p_EventRegistration_SiteConfig] PRIMARY KEY CLUSTERED ( [TContent_ID] ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
</cfquery>

<cfquery name="Create-p_EventRegistration_UserMatrix" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE [dbo].[p_EventRegistration_UserMatrix](
	[TContent_ID] [int] IDENTITY (1, 1) NOT NULL, [Site_ID] [nvarchar] (25) NOT NULL, [User_ID] [nvarchar](35) NOT NULL, [School_District] [int] NOT NULL, [lastUpdateBy] [nvarchar](35) NOT NULL,
		[lastUpdated] [datetime] NOT NULL, CONSTRAINT [PK_p_EventRegistration_UserMatrix] PRIMARY KEY CLUSTERED
	( [TContent_ID] ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY] ) ON [PRIMARY]
</cfquery>

<cfquery name="Create-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE [dbo].[p_EventRegistration_UserRegistrations](
	[TContent_ID] [int] IDENTITY (1, 1) NOT NULL, [Site_ID] [nvarchar] (25) NOT NULL, [RegistrationID] [nvarchar](35) NOT NULL, [RegistrationDate] [datetime] NOT NULL, [User_ID] [nvarchar](35) NOT NULL,
	[EventID] [int] NOT NULL, [RequestsMeal] [bit] NOT NULL, [IVCParticipant] [bit] NOT NULL, [AttendeePrice] [decimal](6, 2) NULL, [RegistrationIPAddr] [nvarchar](10) NULL,
	[RegisterByUserID] [nvarchar](35) NULL, [OnWaitingList] [bit] NOT NULL, [Comments] [nvarchar](max) NULL, [WebinarParticipant] [bit] NOT NULL, [AttendeePriceVerified] [bit] NOT NULL,
	[RegisterForEventDate1] [bit] NOT NULL, [RegisterForEventDate2] [bit] NOT NULL, [RegisterForEventDate3] [bit] NOT NULL, [RegisterForEventDate4] [bit] NOT NULL,
	[RegisterForEventDate5] [bit] NOT NULL, [RegisterForEventDate6] [bit] NOT NULL, [RegisterForEventSessionAM] [bit] NOT NULL, [RegisterForEventSessionPM] [bit] NOT NULL,
	[AttendedEventDate1] [bit] NOT NULL, [AttendedEventDate2] [bit] NOT NULL, [AttendedEventDate3] [bit] NOT NULL, [AttendedEventDate4] [bit] NOT NULL, [AttendedEventDate5] [bit] NOT NULL,
	[AttendedEventDate6] [bit] NOT NULL, [AttendedEventSessionAM] [bit] NOT NULL, [AttendedEventSessionPM] [bit] NOT NULL,
	CONSTRAINT [PK_p_EventRegistration_UserRegistrations_1] PRIMARY KEY CLUSTERED ( [TContent_ID] ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
</cfquery>

<cfquery name="Create-p_EventRegistrations_Events" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE [dbo].[p_EventRegistration_Events](
	[TContent_ID] [int] IDENTITY (1, 1) NOT NULL, [Site_ID] [nvarchar] (25) NOT NULL, [ShortTitle] [nvarchar](50) NULL, [EventDate] [date] NULL, [EventDate1] [date] NULL, [EventDate2] [date] NULL,
	[EventDate3] [date] NULL, [EventDate4] [date] NULL, [EventDate5] [date] NULL, [LongDescription] [nvarchar](max) NULL, [Event_StartTime] [nchar](10) NULL, [Event_EndTime] [nchar](10) NULL,
	[Registration_Deadline] [date] NULL, [Registration_BeginTime] [nchar](10) NULL, [Registration_EndTime] [nchar](10) NULL, [EventFeatured] [bit] NULL, [Featured_StartDate] [nchar](10) NULL,
	[Featured_EndDate] [nchar](10) NULL, [Featured_SortOrder] [int] NULL, [MemberCost] [money] NULL, [NonMemberCost] [money] NULL, [EarlyBird_RegistrationDeadline] [date] NULL,
	[EarlyBird_RegistrationAvailable] [bit] NULL, [EarlyBird_MemberCost] [money] NULL, [EarlyBird_NonMemberCost] [money] NULL, [ViewSpecialPricing] [bit] NULL, [SpecialPriceRequirements] [nvarchar](max) NULL,
	[SpecialMemberCost] [money] NULL, [SpecialNonMemberCost] [money] NULL, [PGPAvailable] [bit] NULL, [PGPPoints] [nvarchar](10) NULL, [MealProvided] [bit] NULL, [MealProvidedBy] [int] NULL,
	[MealCost_Estimated] [money] NULL, [AllowVideoConference] [bit] NULL, [VideoConferenceInfo] [nvarchar](max) NULL, [VideoConferenceCost] [money] NULL, [AcceptRegistrations] [bit] NULL,
	[EventAgenda] [nvarchar](max) NULL, [EventTargetAudience] [nvarchar](max) NULL, [EventStrategies] [nvarchar](max) NULL, [EventSpecialInstructions] [nvarchar](max) NULL,
	[MaxParticipants] [int] NULL, [LocataionID] [int] NULL, [LocationRoomID] [int] NULL, [Presenters] [nvarchar](max) NULL, [Facilitator] [nvarchar](max) NULL, [dateCreated] [date] NULL,
	[lastUpdated] [date] NULL, [lastUpdateBy] [nvarchar](35) NULL, [Active] [bit] NULL, [EventCancelled] [bit] NULL, [WebinarAvailable] [bit] NULL, [WebinarConnectInfo] [nvarchar](max) NULL,
	[WebinarMemberCost] [money] NULL, [WebinarNonMemberCost] [money] NULL, [PostedTo_Facebook] [bit] NULL, [PostedTo_Twitter] [bit] NULL ) ON [PRIMARY]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_Caterers" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_Caterers] ADD  CONSTRAINT [DF_p_EventRegistration_Caterers_isAddressVerified]  DEFAULT ((0)) FOR [isAddressVerified]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_Caterers" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_Caterers] ADD  CONSTRAINT [DF_p_EventRegistration_Caterers_Active]  DEFAULT ((0)) FOR [Active]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_ExpenseList" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_EventExpenses] ADD  CONSTRAINT [DF_p_EventRegistration_EventExpenses_Cost_Verified]  DEFAULT ((0)) FOR [Cost_Verified]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_ExpenseList" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_ExpenseList] ADD  CONSTRAINT [DF_p_EventRegistration_ExpenseList_Active]  DEFAULT ((0)) FOR [Active]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_Facility" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_Facility] ADD  CONSTRAINT [DF_p_EventRegistration_Facility_isAddressVerified]  DEFAULT ((0)) FOR [isAddressVerified]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_Facility" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_Facility] ADD  CONSTRAINT [DF_p_EventRegistration_Facility_Active]  DEFAULT ((0)) FOR [Active]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_Membership" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_Membership] ADD  CONSTRAINT [DF_p_EventRegistration_Membership_ReceiveInvoicesByEmnail]  DEFAULT ((0)) FOR [ReceiveInvoicesByEmnail]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_SiteConfig" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_SiteConfig] ADD  CONSTRAINT [DF_p_EventRegistration_SiteConfig_ProcessPayments_Stripe]  DEFAULT ((0)) FOR [ProcessPayments_Stripe]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_SiteConfig" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_SiteConfig] ADD  CONSTRAINT [DF_p_EventRegistration_SiteConfig_Stripe_TestMode]  DEFAULT ((0)) FOR [Stripe_TestMode]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_RequestsMeal]  DEFAULT ((0)) FOR [RequestsMeal]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_IVCParticipant]  DEFAULT ((0)) FOR [IVCParticipant]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_OnWaitingList]  DEFAULT ((0)) FOR [OnWaitingList]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_WebinarParticipant]  DEFAULT ((0)) FOR [WebinarParticipant]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_AttendeePriceVerified]  DEFAULT ((0)) FOR [AttendeePriceVerified]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_RegisterForEventDate1]  DEFAULT ((0)) FOR [RegisterForEventDate1]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_RegisterForEventDate2]  DEFAULT ((0)) FOR [RegisterForEventDate2]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_RegisterForEventDate3]  DEFAULT ((0)) FOR [RegisterForEventDate3]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_RegisterForEventDate4]  DEFAULT ((0)) FOR [RegisterForEventDate4]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_RegisterForEventDate5]  DEFAULT ((0)) FOR [RegisterForEventDate5]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_RegisterForEventDate6]  DEFAULT ((0)) FOR [RegisterForEventDate6]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_RegisterForEventSessionAM]  DEFAULT ((0)) FOR [RegisterForEventSessionAM]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_RegisterForEventSessionPM]  DEFAULT ((0)) FOR [RegisterForEventSessionPM]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_AttendedEventDate1]  DEFAULT ((0)) FOR [AttendedEventDate1]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_AttendedEventDate2]  DEFAULT ((0)) FOR [AttendedEventDate2]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_AttendedEventDate3]  DEFAULT ((0)) FOR [AttendedEventDate3]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_AttendedEventDate4]  DEFAULT ((0)) FOR [AttendedEventDate4]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_AttendedEventDate5]  DEFAULT ((0)) FOR [AttendedEventDate5]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_AttendedEventDate6]  DEFAULT ((0)) FOR [AttendedEventDate6]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_AttendedEventSessionAM]  DEFAULT ((0)) FOR [AttendedEventSessionAM]
</cfquery>

<cfquery name="AlterTable-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	ALTER TABLE [dbo].[p_EventRegistration_UserRegistrations] ADD  CONSTRAINT [DF_p_EventRegistration_UserRegistrations_AttendedEventSessionPM]  DEFAULT ((0)) FOR [AttendedEventSessionPM]
</cfquery>

<cfquery name="CheckGroups" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Select UserID, GroupName
	From tusers
	Where GroupName LIKE '%Event%'
</cfquery>
<cfif CheckGroups.RecordCount EQ 0>
	<cfscript>
		var NewGroupEventFacilitator = #application.userManager.read("")#;
		NewGroupEventFacilitator.setSiteID(Session.SiteID);
		NewGroupEventFacilitator.setGroupName("Event Facilitator");
		NewGroupEventFacilitator.setType(1);
		NewGroupEventFacilitator.setIsPublic(1);
		NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;
	</cfscript>
	<cfscript>
		var NewGroupEventFacilitator = #application.userManager.read("")#;
		NewGroupEventFacilitator.setSiteID(Session.SiteID);
		NewGroupEventFacilitator.setGroupName("Event Presenter");
		NewGroupEventFacilitator.setType(1);
		NewGroupEventFacilitator.setIsPublic(1);
		NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;
	</cfscript>
<cfelse>
	<cfset GroupPresenterExists = 0>
	<cfset GroupFacilitatorExists = 0>
	<cfloop query="CheckGroup-EventFacilitator">
		<cfif CheckGroups.GroupName EQ "Event Facilitator">
			<cfset GroupFacilitatorExists = 1>
		</cfif>
		<cfif CheckGroups.GroupName EQ "Event Presenter">
			<cfset GroupPresenterExists = 1>
		</cfif>
	</cfloop>
	<cfif GroupFacilitatorExists EQ 0>
		<cfscript>
		var NewGroupEventFacilitator = #application.userManager.read("")#;
		NewGroupEventFacilitator.setSiteID(Session.SiteID);
		NewGroupEventFacilitator.setGroupName("Event Facilitator");
		NewGroupEventFacilitator.setType(1);
		NewGroupEventFacilitator.setIsPublic(1);
		NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;
		</cfscript>
	</cfif>
	<cfif GroupPresenterExists EQ 0>
		<cfscript>
		var NewGroupEventFacilitator = #application.userManager.read("")#;
		NewGroupEventFacilitator.setSiteID(Session.SiteID);
		NewGroupEventFacilitator.setGroupName("Event Presenter");
		NewGroupEventFacilitator.setType(1);
		NewGroupEventFacilitator.setIsPublic(1);
		NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;
		</cfscript>
	</cfif>
</cfif>