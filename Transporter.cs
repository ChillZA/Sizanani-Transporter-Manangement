namespace Sizanani_Transporter_Manangement
{
    public class Transporter
    {
        public class Contractor
        {
            public string Name { get; set; }
            public string Email { get; set; }
            public string Phone { get; set; }

        }

        public class Vehicle
        {
            public string TypeId { get; set; }
            public string Registration_Number { get; set; }
            public string Model { get; set; }
            public int Weight { get; set; }
        }

        public class DisplayVehicle
        {
            public string TypeName { get; set; }
            public string Registration_Number { get; set; }
            public string Model { get; set; }
            public int Weight { get; set; }
        }
    }
}
