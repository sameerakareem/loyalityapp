import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../themes/themeclass.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // About Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildSectionCard(
                  //   icon: Icons.info_outline,
                  //   title: 'About Our Company',
                  //   child: const Text(
                  //     'Al Maqsoud is committed to providing exceptional services to our clients. We pride ourselves on delivering quality solutions and maintaining strong relationships with our customers through dedicated support and professional excellence.',
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       height: 1.6,
                  //       color: Colors.grey,
                  //     ),
                  //   ),
                  // ),


                  // Contact Us Section
                  _buildSectionCard(
                    icon: Icons.contact_support,
                    title: 'Contact Us',
                    child: Column(
                      children: [
                        // Service Hours
                        _buildInfoRow(
                          Icons.access_time,
                          'Service Hours',
                          '09:00 AM - 05:00 PM\nMonday - Saturday',
                          isMultiline: true,
                        ),
                        const SizedBox(height: 16),

                        // Response Time
                        _buildInfoRow(
                          Icons.schedule,
                          'Response Time',
                          'We respond within 2-3 business days',
                        ),
                        const SizedBox(height: 20),

                        const Divider(),
                        const SizedBox(height: 20),

                        // Contact Details
                        _buildContactItem(
                          icon: Icons.phone,
                          title: 'Phone',
                          subtitle: '+971 52 442 9604',
                        //  onTap: () => _launchPhone('+971524429604'),
                        ),
                        const SizedBox(height: 16),

                        _buildContactItem(
                          icon: Icons.email,
                          title: 'Email',
                          subtitle: 'support@almaqsoud.ae',
                         // onTap: () => _launchEmail('support@almaqsoud.ae'),
                        ),
                        const SizedBox(height: 16),

                        _buildContactItem(
                          icon: Icons.location_on,
                          title: 'Location',
                          subtitle: 'Al Maqsoud Head Office, 2nd Floor\nAl Tallah 2, Near Saudi German Hospital\nAjman- United Arab Emirates',
                         // onTap: () => _launchMaps(),
                          isMultiline: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Quick Actions
                  _buildSectionCard(
                    icon: Icons.quick_contacts_dialer,
                    title: 'Quick Actions',
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionButton(
                            icon: Icons.call,
                            label: 'Call Us',
                            color: Colors.green,
                            onTap: () => _launchPhone('+971524429604'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickActionButton(
                            icon: Icons.email,
                            label: 'Email Us',
                            color: Colors.blue,
                            onTap: () => _launchEmail('support@almaqsoud.ae'),
                          ),
                        ),
                        // const SizedBox(width: 12),
                        // Expanded(
                        //   child: _buildQuickActionButton(
                        //     icon: Icons.location_on,
                        //     label: 'Visit Us',
                        //     color: Colors.orange,
                        //     onTap: () => _launchMaps(),
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF2196F3),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle, {bool isMultiline = false}) {
    return Row(
      crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.grey[600],
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
   // required VoidCallback onTap,
    bool isMultiline = false,
  }) {
    return InkWell(
     // onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(phoneUri);
    } catch (e) {
      // Copy to clipboard as fallback
      Clipboard.setData(ClipboardData(text: phoneNumber));
    }
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Inquiry from Mobile App',
    );
    try {
      await launchUrl(emailUri);
    } catch (e) {
      // Copy to clipboard as fallback
      Clipboard.setData(ClipboardData(text: email));
    }
  }

  void _launchMaps() async {
    const String address = 'Al Maqsoud Head Office, Industrial Area 18, Maleha Road, Sharjah, UAE';
    final Uri mapsUri = Uri.parse('https://maps.google.com/search/?api=1&query=${Uri.encodeComponent(address)}');
    try {
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Copy address to clipboard as fallback
      Clipboard.setData(const ClipboardData(text: address));
    }
  }
}