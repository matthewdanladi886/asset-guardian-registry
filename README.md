Asset Guardian Registry

The **Asset Guardian Registry** is a smart contract that allows asset owners to assign and manage guardians for their assets. Guardians can be authorized to act on behalf of an asset owner in specific scenarios, providing an added layer of security and recovery options.

Features

**Assign Guardians:** Asset owners can assign multiple guardians to their assets.
**Verify Guardians:** Check if a given address is a registered guardian for a specific asset.
**Event Tracking:** Emits events when guardians are added or removed.
**Access Control:** Only asset owners can manage guardians.
**Extensible Design:** Ready for future multi-guardian recovery mechanisms.

Usage

1. **Assign a Guardian**  
   Use the `assignGuardian(assetId, guardianAddress)` function to register a guardian for a specific asset.

2. **Remove a Guardian**  
   Use the `removeGuardian(assetId, guardianAddress)` function to remove a guardian.

3. **Verify a Guardian**  
   Use the `isGuardian(assetId, address)` function to check if a given address is a valid guardian for an asset.

Events

- `GuardianAssigned(assetId, guardianAddress)` – Emitted when a guardian is added.
- `GuardianRemoved(assetId, guardianAddress)` – Emitted when a guardian is removed.

Security Considerations

- Only the asset owner can add or remove guardians.
- Input validation is applied to prevent invalid addresses.
- Make sure guardians are trusted parties as they may act on behalf of the owner.

Future Enhancements

- Multi-guardian recovery system
- Time-locked guardian actions
- Integration with other asset management modules

License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
