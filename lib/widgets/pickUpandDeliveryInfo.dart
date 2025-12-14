import 'package:flutter/material.dart';

class PickupAndDeliveryInfo extends StatelessWidget {
  final String title;
  final String address;
  final String subtitle;

  const PickupAndDeliveryInfo({
    super.key,
    required this.title,
    required this.address,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: Text(
                  address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
